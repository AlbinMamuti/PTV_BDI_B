import React, {useState, useContext, createContext} from 'react';
import TextField from '@mui/material/TextField';
import Grid from '@mui/material/Grid'
import Typography from '@mui/material/Typography'
import TimePicker from '@mui/lab/TimePicker';

import { ClientDataContext } from './clientDataContext';
import { PickData} from './PackageForm';



const PickUpAddr = () =>{

    const [pickTime, setPickTime] = useState("")
    const [pickAddress, setPickAddress] = useState("")
    const [clientPickData, setClientPickData] = useContext(PickData)


  
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
               
            </Grid>
        </div>
    )
}

export default PickUpAddr;