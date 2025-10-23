(define (domain lunar)
  (:requirements :strips :typing)

  ;;object types
  (:types
    rover
    lander
    waypoint
    sample
    image
    scan
  )

  ;;describe the state of the world.
  (:predicates
    ;;Location and deployment
    (rover_at ?r - rover ?w - waypoint)
    (lander_at ?l - lander ?w - waypoint)
    (undeployed ?r - rover)
    (connected ?from - waypoint ?to - waypoint)

    ;;Rover memory
    (empty_memory ?r - rover)

    ;;Sample/data handling 
    (image_at ?w - waypoint)
    (scan_at ?w - waypoint)
    (sample_at ?w - waypoint)

    ;;Rover storage
    (holding_image ?r - rover)
    (holding_scan ?r - rover)
    (holding_sample ?r - rover)

    ;;Transmission and storage result
    (stored_sample ?l - lander)
    (transmit_scan ?r - rover ?w - waypoint)
    (transmit_image ?r - rover ?w - waypoint)

    ;;Landing status 
    (has_landed ?l)
  )

  ;;Land the lander if inital state, states that lander has_not_landed
  (:action land_lander
      :parameters (?l - lander ?w - waypoint)
      :precondition (not(has_landed ?l)) 
      :effect (and(has_landed ?l) (lander_at ?l ?w))
  )
  
  ;; Deploy rover from lander
  (:action deploy_rover
    :parameters (?r - rover ?l - lander ?w - waypoint)
    :precondition (and
      (lander_at ?l ?w)
      (undeployed ?r)
    )
    :effect (and
      (not (undeployed ?r))
      (rover_at ?r ?w)
    )
  )

  ;;move rover between waypoints
  (:action move
    :parameters (?r - rover ?from - waypoint ?to - waypoint)
    :precondition (and
      (rover_at ?r ?from)
      (connected ?from ?to)
    )
    :effect (and
      (not (rover_at ?r ?from))
      (rover_at ?r ?to)
    )
  )

  ;;Collect image/scan/sample from waypoint and hold it
  (:action collect_image
    :parameters (?r - rover ?w - waypoint)
    :precondition (and
      (rover_at ?r ?w)
      (image_at ?w)
      (empty_memory ?r)
    )
    :effect (and
      (not (empty_memory ?r))
      (holding_image ?r)
    )
  )

  ;;Collect image/scan/sample from waypoint and hold it
  (:action collect_scan
    :parameters (?r - rover ?w - waypoint)
    :precondition (and
      (rover_at ?r ?w)
      (scan_at ?w)
      (empty_memory ?r)
    )
    :effect (and
      (not (empty_memory ?r))
      (holding_scan ?r)
    )
  )

  ;;Collect image/scan/sample from waypoint and hold it
  (:action collect_sample
    :parameters (?r - rover ?w - waypoint)
    :precondition (and
      (rover_at ?r ?w)
      (sample_at ?w)
      (empty_memory ?r)
    )
    :effect (and
       (not (empty_memory ?r))
       (holding_sample ?r)
    )
  )

  ;;trasmit image when rover is holding
  (:action transmit_image
    :parameters (?r - rover ?w - waypoint)
    :precondition (and (rover_at ?r ?w) (holding_image ?r))
    :effect (and
      (not (holding_image ?r))
      (empty_memory ?r)
      (transmit_image ?r ?w)
    )
  )

  ;;trasmit scan when rover is holding scan
  (:action transmit_scan
    :parameters (?r - rover ?w - waypoint)
    :precondition (and (rover_at ?r ?w) (holding_scan ?r))
    :effect (and
      (not (holding_scan ?r))
      (empty_memory ?r)
      (transmit_scan ?r ?w)
    )
  )

  ;;store sample at lander location
  (:action store_sample
    :parameters (?r - rover ?l - lander ?w - waypoint)
    :precondition (and
        (rover_at ?r ?w)
        (lander_at ?l ?w)
        (holding_sample ?r)
      )
    :effect (and
      (not (holding_sample ?r))
      (empty_memory ?r)
      (stored_sample ?l)
    )
  ) 
)
