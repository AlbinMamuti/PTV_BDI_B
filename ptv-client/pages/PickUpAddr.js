import React, {useState, useContext} from 'react';
import TextField from '@mui/material/TextField';
import Grid from '@mui/material/Grid'
import Typography from '@mui/material/Typography'
import TimePicker from '@mui/lab/TimePicker';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormHelperText from '@mui/material/FormHelperText';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';


const PickUpAddr = () =>{

    const [pickTime, setPickTime] = useState("")
    const [pickAddress, setPickAddress] = useState("")
    const [pickupPriority, setPickupPriority] = useState("");

  const handleChange = (event) => {
    setPickupPriority(event.target.value);
    console.log(pickTime)
  };
    return (
        <div>
            <Grid container spacing={1}>
                <Grid item xs = {12}>
                    <Typography variant='h4'>PickUp-Addr</Typography>
                </Grid>
                <Grid item xs={8}>
                    <TextField
                        required
                        id="outlined-required"
                        label="Address Line 1"
                        onChange={(newValue) => {
                            setPickAddress({addr1: newValue});
                        }}
                        fullWidth
                    />
                </Grid>
                <Grid item xs={8}>
                    <TextField
                        id="outlined-required"
                        label="Address Line 2"
                        onChange={(newValue) => {
                            setPickAddress({addr2: newValue});
                        }}
                        fullWidth
                    />
                </Grid>
                <Grid item xs={8}>
                    <TextField
                        required
                        id="outlined-required"
                        label="City"
                        onChange={(newValue) => {
                            setPickAddress({city: newValue});
                        }}
                        fullWidth
                    />
                </Grid>
                <Grid item xs={6}>
                    <TextField
                        required
                        id="outlined-required"
                        label="State"
                        onChange={(newValue) => {
                            setPickAddress({state: newValue});
                        }}
                        fullWidth
                    />
                </Grid>
                <Grid item xs={6}>
                    <TextField
                        required
                        id="outlined-required"
                        label="ZIP"
                        onChange={(newValue) => {
                            setPickAddress({zip: newValue});
                        }}
                        fullWidth
                    />
                </Grid>
                <Grid item xs={6}>
                <TimePicker
                            label="PickupTime Start"
                            value={pickTime.start}
                            onChange={(newValue) => {
                            setPickTime({start: newValue});
                            }}
                            renderInput={(params) => <TextField {...params} />}
                        />
                </Grid>
                {/* <Grid item xs = {1}>
                    <Typography variant='h5'>to</Typography>
                </Grid> */}
                <Grid item xs = {6}>
                    <TimePicker
                            label="PickupTime End"
                            value={pickTime.end}
                            onChange={(newValue) => {
                            setPickTime({end: newValue});
                            }}
                            renderInput={(params) => <TextField {...params} />}
                        />
                </Grid>
                <Grid item xs = {12}>
                    <FormControl sx={{ m: 1, minWidth: 120 }}>
                    <InputLabel id="pickup-priority-helper-label">Priority</InputLabel>
                    <Select
                    labelId="pickup-priority-helper-label"
                    id="pickup-priority-select-helper"
                    value={pickupPriority}
                    label="Priority"
                    onChange={handleChange}
                    required
                    >
                    <MenuItem value="">
                        <em>None</em>
                    </MenuItem>
                    <MenuItem value={1}>1</MenuItem>
                    <MenuItem value={2}>2</MenuItem>
                    <MenuItem value={3}>3</MenuItem>
                    <MenuItem value={4}>4</MenuItem>
                    <MenuItem value={5}>5</MenuItem>
                    <MenuItem value={6}>6</MenuItem>
                    <MenuItem value={7}>7</MenuItem>
                    <MenuItem value={8}>8</MenuItem>
                    <MenuItem value={9}>9</MenuItem>
                    </Select>
                    <FormHelperText>Price will be calculated based on distance and priority</FormHelperText>
                    </FormControl>
                </Grid>
            </Grid>

        </div>
    )
}

export default PickUpAddr;