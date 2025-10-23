(define (problem lunar-mission-1)
  (:domain lunar)

  (:objects
    lander - lander
    rover - rover
    wp1 wp2 wp3 wp4 wp5 - waypoint
    sample - sample
    image - image
    scan - scan
  )

  (:init
    ;; initial lander and rover state
    (lander_at lander wp3)
    (has_landed lander)
    (undeployed rover)
    (empty_memory rover)

    ;; map connectivity
    (connected wp5 wp1)
    (connected wp1 wp2)
    (connected wp2 wp3)
    (connected wp3 wp5)
    (connected wp1 wp4)
    (connected wp4 wp3)

    ;;sample/data location
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
