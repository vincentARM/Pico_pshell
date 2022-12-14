.equ acosf                         ,  0x100233a9
.equ acoshf                        ,  0x1002358d
.equ adc_fifo_drain                ,  0x10009f2d
.equ adc_fifo_get                  ,  0x10009f09
.equ adc_fifo_get_blocking         ,  0x10009f15
.equ adc_fifo_get_level            ,  0x10009ef9
.equ adc_fifo_is_empty             ,  0x10009ee9
.equ adc_fifo_setup                ,  0x10009ea9
.equ adc_get_selected_input        ,  0x10009e0d
.equ adc_gpio_init                 ,  0x1000a42d
.equ adc_init                      ,  0x10026b8d
.equ adc_irq_set_enabled           ,  0x10009f55
.equ adc_read                      ,  0x10009e55
.equ adc_run                       ,  0x10009e75
.equ adc_select_input              ,  0x10009df1
.equ adc_set_clkdiv                ,  0x10009e91
.equ adc_set_round_robin           ,  0x10009e1d
.equ adc_set_temp_sensor_enabled   ,  0x10009e39
.equ asinf                         ,  0x10023369
.equ asinhf                        ,  0x100234d9
.equ atan2f                        ,  0x1002310d
.equ atanf                         ,  0x100233e9
.equ atanhf                        ,  0x100235fd
.equ atoi                          ,  0x10027465
.equ clock_configure               ,  0x1001fced
.equ clock_configure_gpin          ,  0x100201a1
.equ clock_get_hz                  ,  0x100200bd
.equ clock_gpio_init               ,  0x10020151
.equ clocks_enable_resus           ,  0x1002011d
.equ clock_set_reported_hz         ,  0x100200c9
.equ clocks_init                   ,  0x1001fe01
.equ clock_stop                    ,  0x1001fcc1
.equ close                         ,  0x1000af79
.equ cosf                          ,  0x10023079
.equ coshf                         ,  0x10023451
.equ exit                          ,  0x1000a3ad
.equ fmodf                         ,  0x10023801
.equ free                          ,  0x1000ab99
.equ frequency_count_khz           ,  0x100200d5
.equ frequency_count_mhz           ,  0x1000a3c1
.equ getchar                       ,  0x100240c5
.equ getchar_timeout_us            ,  0x10024139
.equ gpio_acknowledge_irq          ,  0x1001e129
.equ gpio_add_raw_irq_handler      ,  0x1000a3d9
.equ gpio_add_raw_irq_handler_masked,  0x1001e091
.equ gpio_add_raw_irq_handler_with_order_priority,  0x1000a3e9
.equ gpio_add_raw_irq_handler_with_order_priority_masked,  0x1001e04d
.equ gpio_clr_mask                 ,  0x10009d3d
.equ gpio_deinit                   ,  0x1001e1a9
.equ gpio_disable_pulls            ,  0x1000a421
.equ gpio_get                      ,  0x10009d1d
.equ gpio_get_all                  ,  0x10009d2d
.equ gpio_get_dir                  ,  0x10009ddd
.equ gpio_get_drive_strength       ,  0x1001def5
.equ gpio_get_function             ,  0x1001dd91
.equ gpio_get_irq_event_mask       ,  0x10009ce9
.equ gpio_get_out_level            ,  0x10009d79
.equ gpio_get_slew_rate            ,  0x1001dec1
.equ gpio_init                     ,  0x1001e16d
.equ gpio_init_mask                ,  0x1001e1d9
.equ gpio_is_dir_out               ,  0x10009dc9
.equ gpio_is_input_hysteresis_enabled,  0x1001de8d
.equ gpio_is_pulled_down           ,  0x10009cd5
.equ gpio_is_pulled_up             ,  0x10009cc1
.equ gpio_pull_down                ,  0x1000a415
.equ gpio_pull_up                  ,  0x1000a409
.equ gpio_put                      ,  0x10009d65
.equ gpio_put_all                  ,  0x10009d5d
.equ gpio_put_masked               ,  0x10009d4d
.equ gpio_remove_raw_irq_handler   ,  0x1000a3f9
.equ gpio_remove_raw_irq_handler_masked,  0x1001e0c9
.equ gpio_set_dir                  ,  0x10009db5
.equ gpio_set_dir_all_bits         ,  0x10009dad
.equ gpio_set_dir_in_masked        ,  0x10009d95
.equ gpio_set_dir_masked           ,  0x10009d9d
.equ gpio_set_dir_out_masked       ,  0x10009d8d
.equ gpio_set_dormant_irq_enabled  ,  0x1001e0e9
.equ gpio_set_drive_strength       ,  0x1001ded5
.equ gpio_set_function             ,  0x1001dd61
.equ gpio_set_inover               ,  0x1001ddf9
.equ gpio_set_input_enabled        ,  0x1001e145
.equ gpio_set_input_hysteresis_enabled,  0x1001de65
.equ gpio_set_irq_callback         ,  0x1001e00d
.equ gpio_set_irq_enabled          ,  0x1001df09
.equ gpio_set_irq_enabled_with_callback,  0x1001df5d
.equ gpio_set_irqover              ,  0x1001ddd5
.equ gpio_set_mask                 ,  0x10009d35
.equ gpio_set_oeover               ,  0x1001de41
.equ gpio_set_outover              ,  0x1001de1d
.equ gpio_set_pulls                ,  0x1001dda5
.equ gpio_set_slew_rate            ,  0x1001dea1
.equ gpio_xor_mask                 ,  0x10009d45
.equ i2c_deinit                    ,  0x10026e6d
.equ i2c_get_dreq                  ,  0x10009fd1
.equ i2c_get_hw                    ,  0x10009f7d
.equ i2c_get_read_available        ,  0x10009f8d
.equ i2c_get_write_available       ,  0x10009f81
.equ i2c_hw_index                  ,  0x10009f6d
.equ i2c_init                      ,  0x10026f51
.equ i2c_read_blocking             ,  0x10027145
.equ i2c_read_raw_blocking         ,  0x10009fb1
.equ i2c_read_timeout_per_char_us  ,  0x10027239
.equ i2c_read_timeout_us           ,  0x1000a505
.equ i2c_set_baudrate              ,  0x10026e8d
.equ i2c_set_slave_mode            ,  0x10026fa5
.equ i2c_write_blocking            ,  0x10026fe5
.equ i2c_write_raw_blocking        ,  0x10009f95
.equ i2c_write_timeout_per_char_us ,  0x100270fd
.equ i2c_write_timeout_us          ,  0x1000a4a9
.equ irq_add_shared_handler        ,  0x1001e521
.equ irq_clear                     ,  0x10009cad
.equ irq_get_exclusive_handler     ,  0x1001e4d1
.equ irq_get_priority              ,  0x1001e8e1
.equ irq_get_vtable_handler        ,  0x1001e46d
.equ irq_has_shared_handler        ,  0x1001e441
.equ irq_init_priorities           ,  0x1001e9b5
.equ irq_is_enabled                ,  0x1001e3f9
.equ irq_remove_handler            ,  0x1001e705
.equ irq_set_enabled               ,  0x1001e3d5
.equ irq_set_exclusive_handler     ,  0x1001e47d
.equ irq_set_mask_enabled          ,  0x1001e411
.equ irq_set_pending               ,  0x1001e431
.equ irq_set_priority              ,  0x1001e8b9
.equ log10f                        ,  0x10023641
.equ logf                          ,  0x1002312d
.equ lseek                         ,  0x1000a491
.equ malloc                        ,  0x1000acb1
.equ memcmp                        ,  0x20000735
.equ memcpy                        ,  0x10023b4d
.equ memset                        ,  0x10023b41
.equ open                          ,  0x1000b2b1
.equ opendir                       ,  0x1000b221
.equ popcount                      ,  0x1000a489
.equ powf                          ,  0x10023655
.equ printf                        ,  0x1000ac85
.equ putchar                       ,  0x10023d7d
.equ pwm_advance_count             ,  0x1000a169
.equ pwm_clear_irq                 ,  0x1000a2f1
.equ pwm_config_set_clkdiv         ,  0x1000a009
.equ pwm_config_set_clkdiv_int     ,  0x1000a029
.equ pwm_config_set_clkdiv_int_frac,  0x1000a021
.equ pwm_config_set_clkdiv_mode    ,  0x1000a035
.equ pwm_config_set_output_polarity,  0x1000a045
.equ pwm_config_set_phase_correct  ,  0x10009ff9
.equ pwm_config_set_wrap           ,  0x1000a065
.equ pwm_force_irq                 ,  0x1000a30d
.equ pwm_get_counter               ,  0x1000a13d
.equ pwm_get_default_config        ,  0x1000a091
.equ pwm_get_dreq                  ,  0x1000a31d
.equ pwm_get_irq_status_mask       ,  0x1000a301
.equ pwm_gpio_to_channel           ,  0x10009ff1
.equ pwm_gpio_to_slice_num         ,  0x10009fe9
.equ pwm_init                      ,  0x1000a069
.equ pwm_retard_count              ,  0x1000a18d
.equ pwm_set_both_levels           ,  0x1000a0ed
.equ pwm_set_chan_level            ,  0x1000a0b9
.equ pwm_set_clkdiv                ,  0x1000a1c9
.equ pwm_set_clkdiv_int_frac       ,  0x1000a1b1
.equ pwm_set_clkdiv_mode           ,  0x1000a241
.equ pwm_set_counter               ,  0x1000a155
.equ pwm_set_enabled               ,  0x1000a28d
.equ pwm_set_gpio_level            ,  0x1000a105
.equ pwm_set_irq_enabled           ,  0x1000a2bd
.equ pwm_set_irq_mask_enabled      ,  0x1000a2d9
.equ pwm_set_mask_enabled          ,  0x1000a2b1
.equ pwm_set_output_polarity       ,  0x1000a20d
.equ pwm_set_phase_correct         ,  0x1000a265
.equ pwm_set_wrap                  ,  0x1000a0a5
.equ rand                          ,  0x100281d1
.equ read                          ,  0x1000a761
.equ readdir                       ,  0x1000a731
.equ remove                        ,  0x1000a475
.equ rename                        ,  0x1000b0b5
.equ screen_height                 ,  0x1000a461
.equ screen_width                  ,  0x1000a44d
.equ sinf                          ,  0x1002309d
.equ sinhf                         ,  0x10023415
.equ sleep_ms                      ,  0x1001f199
.equ sleep_us                      ,  0x1001f169
.equ spi_deinit                    ,  0x10027379
.equ spi_get_baudrate              ,  0x10027449
.equ spi_get_const_hw              ,  0x1000acad
.equ spi_get_dreq                  ,  0x1000a38d
.equ spi_get_hw                    ,  0x1000a331
.equ spi_get_index                 ,  0x1000a321
.equ spi_init                      ,  0x10027281
.equ spi_is_busy                   ,  0x1000a385
.equ spi_is_readable               ,  0x1000a37d
.equ spi_is_writable               ,  0x1000a375
.equ spi_read16_blocking           ,  0x20000649
.equ spi_read_blocking             ,  0x20000511
.equ spi_set_baudrate              ,  0x100273b5
.equ spi_set_format                ,  0x1000a335
.equ spi_set_slave                 ,  0x1000a355
.equ spi_write16_blocking          ,  0x200005f9
.equ spi_write16_read16_blocking   ,  0x20000585
.equ spi_write_blocking            ,  0x200004c5
.equ spi_write_read_blocking       ,  0x20000451
.equ sprintf                       ,  0x1000ac99
.equ sqrtf                         ,  0x10023059
.equ srand                         ,  0x100281bd
.equ strcat                        ,  0x100286b9
.equ strchr                        ,  0x10028705
.equ strcmp                        ,  0x100287c5
.equ strcpy                        ,  0x1002884d
.equ strdup                        ,  0x1000ace1
.equ strlen                        ,  0x10028b9d
.equ strncat                       ,  0x10028c49
.equ strncmp                       ,  0x10028cad
.equ strncpy                       ,  0x10028d21
.equ strrchr                       ,  0x10028de5
.equ tanf                          ,  0x100230c1
.equ tanhf                         ,  0x1002348d
.equ time_us_32                    ,  0x10009f61
.equ user_irq_claim                ,  0x1001e9d9
.equ user_irq_claim_unused         ,  0x1001ea15
.equ user_irq_is_claimed           ,  0x1001ea45
.equ user_irq_unclaim              ,  0x1001e9f9
.equ wfi                           ,  0x1000a3a9
.equ write                         ,  0x1000a561
