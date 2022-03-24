import React, {useState, useContext} from 'react';
import PickUpAddr from './PickUpAddr'
import { Button, TextField, Grid, Typography, Stack } from '@mui/material';

import {SendIcon, DeleteIcon} from '@mui/icons-material'

// to get live time
import AdapterDateFns from '@mui/lab/AdapterDateFns';
import LocalizationProvider from '@mui/lab/LocalizationProvider';
import { TimePicker } from '@mui/lab';



const PackageForm = () =>{


    return(
        // <LocalizationProvider DateAdapter={DateAdapter}>
        <div>
            <LocalizationProvider dateAdapter={AdapterDateFns}>
                <Grid container spacing={2}>
                    <Grid item xs={8}>
                        <Typography variant='h5'>Please register the packet you want to be delivered</Typography>
                    </Grid>
                    <Grid item xs={8}>
                        <TextField
                        required
                        id="outlined-required"
                        label="Packet-Description"
                        fullWidth
                        />
                    </Grid>
                    <Grid item xs={4}></Grid>
                    <Grid item xs={12}>
                    <PickUpAddr></PickUpAddr>
                    </Grid>
                    <Grid item xs = {6}>
                        <Button variant="outlined">Delete</Button>
                    </Grid>
                    <Grid item xs = {6}>
                        <Stack direction="row" justifyContent="end">
                            <Button variant="contained">Submit</Button>
                        </Stack>
                    </Grid>
                </Grid>
                
            </LocalizationProvider>

        </div>
    );
}
export default PackageForm;