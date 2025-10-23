(define (domain lunar-extended)
  (:requirements :strips :typing)

  (:types
    rover
    lander
    waypoint
    sample
    image
    scan
      
    astronaut
    area
  )

  ;; describe the state of the world 
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

    (astronaut_at ?a - astronaut ?l - lander ?ar - area)
    (in_control_room ?ar - area)
    (in_docking_bay ?ar - area)
  )

  ;; move astronaut from one area to another
  (:action move_astronaut
      :parameters (?a - astronaut ?l - lander ?from - area ?to - area)
      :precondition (and 
        (astronaut_at ?a ?l ?from)
        (or (and (in_control_room ?from) (in_docking_bay ?to))
            (and (in_docking_bay ?from) (in_control_room ?to)))
      )
      :effect (and 
        (not (astronaut_at ?a ?l ?from))
        (astronaut_at ?a ?l ?to))
    )
  
  (:action land_lander
      :parameters (?l - lander ?w - waypoint)
      :precondition (not(has_landed ?l))
      :effect (and(has_landed ?l) (lander_at ?l ?w))
  )
  
  ;; Astronant need to be at docking bay to deploy rover
  (:action deploy_rover
    :parameters (?r - rover ?l - lander ?w - waypoint
        ?a - astronaut ?ar - area
    )
    :precondition (and
      (lander_at ?l ?w)
      (undeployed ?r)

      (astronaut_at ?a ?l ?ar)
      (in_docking_bay ?ar)
    )
    :effect (and
      (not (undeployed ?r))
      (rover_at ?r ?w)
    )
  )

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

  ;; Astronant need to be at control room to collect transmission of image
  (:action transmit_image
    :parameters (?r - rover ?w - waypoint ?l - lander ?a - astronaut ?ar - area)
    :precondition (and (rover_at ?r ?w) (holding_image ?r)

        (astronaut_at ?a ?l ?ar)
        (in_control_room ?ar)
    )
    :effect (and
      (not (holding_image ?r))
      (empty_memory ?r)
      (transmit_image ?r ?w)
    )
  )

  ;; Astronant need to be at control room to collect transmission of scan
  (:action transmit_scan
    :parameters (?r - rover ?w - waypoint ?l - lander ?a - astronaut ?ar - area)
    :precondition (and (rover_at ?r ?w) (holding_scan ?r)

        (astronaut_at ?a ?l ?ar)
        (in_control_room ?ar)
    )
    :effect (and
      (not (holding_scan ?r))
      (empty_memory ?r)
      (transmit_scan ?r ?w)
    )
  )

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

  ;; Astronant need to be at docking bay to collect sample
  (:action store_sample
    :parameters (?r - rover ?l - lander ?w - waypoint
        ?a - astronaut ?ar - area)
    :precondition (and
        (rover_at ?r ?w)
        (lander_at ?l ?w)
        (holding_sample ?r)

        (astronaut_at ?a ?l ?ar)
        (in_docking_bay ?ar)
      )
    :effect (and
      (not (holding_sample ?r))
      (empty_memory ?r)
      (stored_sample ?l)
    )
  ) 
)
