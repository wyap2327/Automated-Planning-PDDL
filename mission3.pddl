(define (problem lunar-mission-3)
  (:domain lunar-extended)

  (:objects
    lander1 lander2 - lander
    rover1 rover2 - rover
    wp1 wp2 wp3 wp4 wp5 wp6 - waypoint
    sample1 sample2 - sample
    image1 image2 - image
    scan1 scan2 - scan
    alice bob - astronaut
    control1 dock1 control2 dock2 - area
  )

  (:init
    ;; initial lander and rover state
    (lander_at lander1 wp2)
    (rover_at rover1 wp2)
    (empty_memory rover1)

    (not (has_landed lander2))
    (undeployed rover2)
    (empty_memory rover2)

    ;; map connectivity
    (connected wp1 wp2)
    (connected wp2 wp1)
    (connected wp2 wp3)
    (connected wp3 wp2)
    (connected wp2 wp4)
    (connected wp4 wp2)
    (connected wp3 wp5)
    (connected wp5 wp3)
    (connected wp4 wp6)
    (connected wp6 wp4)
    (connected wp5 wp6)
    (connected wp6 wp5)

    ;;sample/data location
    (sample_at wp1)
    (sample_at wp5)
    (image_at wp2)
    (image_at wp3)
    (scan_at wp4)
    (scan_at wp6)

    ;; areas in landers
    (in_docking_bay dock1)
    (in_control_room control1)
    (in_docking_bay dock2)
    (in_control_room control2)

    ;; inital astonaunt area
    (astronaut_at alice lander1 dock1)
    (astronaut_at bob lander2 control2)
  )

  (:goal (and
    (transmit_image rover1 wp3)
    (transmit_scan rover1 wp4)
    (transmit_image rover2 wp2)
    (transmit_scan rover2 wp6)
    (stored_sample lander1)
    (stored_sample lander2)
  ))
)
