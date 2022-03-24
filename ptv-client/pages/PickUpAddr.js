import React, {Component} from 'react'
import TextField from '@mui/material/TextField';
import Grid from '@mui/material/Grid'
import Typography from '@mui/material/Typography'
// import TimePicker from '@mui/lab/TimePicker';

const PickUpAddr = () =>{
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
                    fullWidth
                />
            </Grid>
            <Grid item xs={8}>
                <TextField
                    required
                    id="outlined-required"
                    label="Address Line 2"
                    fullWidth
                />
            </Grid>
            <Grid item xs={8}>
                <TextField
                    required
                    id="outlined-required"
                    label="City"
                    fullWidth
                />
            </Grid>
            <Grid item xs={6}>
                <TextField
                    required
                    id="outlined-required"
                    label="State"
                    fullWidth
                />
            </Grid>
            <Grid item xs={6}>
                <TextField
                    required
                    id="outlined-required"
                    label="ZIP"
                    fullWidth
                />
            </Grid>
            
        </Grid>
        </div>
    )
}

export default PickUpAddr;