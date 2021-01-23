function read_voltage()
    -- power on reader
    gpio.mode(ADC_READER_POWER_PIN, gpio.OUTPUT)
    gpio.write(ADC_READER_POWER_PIN, gpio.HIGH)

    adc.force_init_mode(adc.INIT_ADC)
    voltage = adc.read(0)

    -- power of reader
    gpio.write(ADC_READER_POWER_PIN, gpio.LOW)

    return voltage
end
