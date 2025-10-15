(define (domain lunar)
  (:requirements :strips :typing)

  (:types
    rover
    lander
    waypoint
    sample
    image
    scan
  )

  (:predicates
    (rover_at ?r - rover ?w - waypoint)
    (lander_at ?l - lander ?w - waypoint)
    (undeployed ?r - rover)
    (connected ?from - waypoint ?to - waypoint)

    (empty_memory ?r - rover)

    (image_at ?w - waypoint)
    (scan_at ?w - waypoint)
    (sample_at ?w - waypoint)

    (holding_image ?r - rover)
    (holding_scan ?r - rover)
    (holding_sample ?r - rover)

    (stored_sample ?l - lander)
    (transmit_scan ?r - rover ?w - waypoint)
    (transmit_image ?r - rover ?w - waypoint)

    (has_landed ?l)
  )

  (:action land_lander
      :parameters (?l ?w)
      :precondition (not(has_landed ?l))
      :effect (and(has_landed ?l) (lander_at ?l ?w))
  )
  
  
  (:action deploy_rover
    :parameters (?r - rover ?l - lander ?w - waypoint)
    :precondition (and
      (lander_at ?l ?w)
      (undeployed ?r))
    :effect (and
      (not (undeployed ?r))
      (rover_at ?r ?w))
  )

  (:action move
    :parameters (?r - rover ?from - waypoint ?to - waypoint)
    :precondition (and
      (rover_at ?r ?from)
      (connected ?from ?to))
    :effect (and
      (not (rover_at ?r ?from))
      (rover_at ?r ?to))
  )

  (:action collect-image
    :parameters (?r - rover ?w - waypoint)
    :precondition (and
      (rover_at ?r ?w)
      (image_at ?w)
      (empty_memory ?r))
    :effect (and
      (not (empty_memory ?r))
      (holding_image ?r))
  )

  (:action collect-scan
    :parameters (?r - rover ?w - waypoint)
    :precondition (and
      (rover_at ?r ?w)
      (scan_at ?w)
      (empty_memory ?r))
    :effect (and
      (not (empty_memory ?r))
      (holding_scan ?r))
  )

  (:action transmit_image
    :parameters (?r - rover ?w - waypoint)
    :precondition (and (rover_at ?r ?w) (holding_image ?r))
    :effect (and
      (not (holding_image ?r))
      (empty_memory ?r)
      (transmit_image ?r ?w))
  )

  (:action transmit_scan
    :parameters (?r - rover ?w - waypoint)
    :precondition (and (rover_at ?r ?w) (holding_scan ?r))
    :effect (and
      (not (holding_scan ?r))
      (empty_memory ?r)
      (transmit_scan ?r ?w))
  )

  (:action collect-sample
    :parameters (?r - rover ?w - waypoint)
    :precondition (and
      (rover_at ?r ?w)
      (sample_at ?w)
      (empty_memory ?r))
    :effect (and
      (not (empty_memory ?r))
      (holding_sample ?r))
  )

  (:action store-sample
    :parameters (?r - rover ?l - lander ?w - waypoint)
    :precondition (and
      (rover_at ?r ?w)
      (lander_at ?l ?w)
      (holding_sample ?r))
    :effect (and
      (not (holding_sample ?r))
      (empty_memory ?r)
      (stored_sample ?l))
  )
)
