(define (problem lunar-mission-1)
  (:domain lunar)

  (:objects
    lander 
    rover 
    wp1 wp2 wp3 wp4 wp5 - waypoint
    sample 
    image
    scan
  )

  (:init
    ;; Initial lander and rover state
    (lander_at lander wp3)
    (undeployed rover)
    (empty_memory rover)

    ;; Map connectivity
    (connected wp5 wp1)
    (connected wp1 wp2)
    (connected wp2 wp3)
    (connected wp3 wp5)
    (connected wp1 wp4)
    (connected wp4 wp3)

    ;; Objects at waypoints
    (sample_at wp1)
    (image_at wp5)
    (scan_at wp3)
  )

  (:goal (and
    (transmit_image rover wp5)
    (transmit_scan rover wp3)
    (stored_sample lander)
  ))
)
