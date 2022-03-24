import React, { useState, useContext, createContext } from "react";
import PickUpAddr from "./PickUpAddr";
import FormHelperText from "@mui/material/FormHelperText";
import FormControl from "@mui/material/FormControl";
import Select from "@mui/material/Select";
import InputLabel from "@mui/material/InputLabel";
import MenuItem from "@mui/material/MenuItem";


import TimePicker from "@mui/lab/TimePicker";

import { Button, TextField, Grid, Typography, Stack } from "@mui/material";

import { SendIcon, DeleteIcon } from "@mui/icons-material";

import { app, db, GeoPoint } from '../firebase/initFirebase.js'
import { collection, addDoc } from "firebase/firestore"; 



// to get live time
import AdapterDateFns from "@mui/lab/AdapterDateFns";
import LocalizationProvider from "@mui/lab/LocalizationProvider";

const PackageForm = () => {
  //   const [clientPickData, setClientPickData] = useState("");

  const [description, setDescription] = useState("");
  const [pickupPriority, setPickupPriority] = useState("");
  const [pickTimeStart, setPickTimeStart] = useState("");
  const [pickTimeEnd, setPickTimeEnd] = useState("");
  const [pickAddress1, setPickAddress1] = useState("");
  const [pickAddress2, setPickAddress2] = useState("");
  const [pickCity, setPickCity] = useState("");
  const [pickZIP, setPickZIP] = useState("");
  const [pickState, setPickState] = useState("");

  const [dropTimeStart, setDropTimeStart] = useState("");
  const [dropTimeEnd, setDropTimeEnd] = useState("");
  const [dropAddress1, setDropAddress1] = useState("");
  const [dropAddress2, setDropAddress2] = useState("");
  const [dropCity, setDropCity] = useState("");
  const [dropZIP, setDropZIP] = useState("");
  const [dropState, setDropState] = useState("");

  const insertDB = async () => {
    const pickupAddress = pickAddress1 + ", " + pickAddress2 + "," + pickCity + " " + pickZIP + ", " + pickState;
    const pickupCoords = await getCoordinates(pickupAddress);
    const pickupLocation = new GeoPoint(pickupCoords.latitude, pickupCoords.longitude);

    const dropoffAddress = dropAddress1 + ", " + dropAddress2 + "," + dropCity + " " + dropZIP + ", " + dropState;
    const dropoffCoords = await getCoordinates(pickupAddress);
    const dropoffLocation = new GeoPoint(dropoffCoords.latitude, dropoffCoords.longitude);

    await addDoc(collection(db, "Orders"), {
      ClientID: "1",
      Description: description,
      Priority: pickupPriority,
      PickupLocation: pickupLocation,
      DropoffLocation: dropoffLocation,
      Status: 0,
    });

  };

  const handleChange = (event) => {
    setPickupPriority(event.target.value);
    console.log(pickTimeStart);
  };

  return (
    // <LocalizationProvider DateAdapter={DateAdapter}>
    <div>
      <LocalizationProvider dateAdapter={AdapterDateFns}>
        <Grid container spacing={2}>
          <Grid item xs={12}>
            <Typography variant="h5">
              Please register the packet you want to be delivered
            </Typography>
          </Grid>
          <Grid item xs={8}>
            <TextField
              required
              id="outlined-required"
              label="Packet-Description"
              onChange={(event) => {
                setDescription(event.target.value);
              }}
              fullWidth
            />
          </Grid>
          <Grid item xs={4}></Grid>
          <Grid item xs={12}>
            <Grid container spacing={1}>
              <div style={{ marginTop: "12px" }}>
                  <Typography variant="h4">PickUp-Addr</Typography>
                </div>
              {/* begin pickup address form */}
              <Grid item xs={8}>
                <TextField
                  required
                  id="outlined-required"
                  label="Address Line 1"
                  onChange={(event) => {
                    setPickAddress1(event.target.value);
                  }}
                  fullWidth
                />
              </Grid>
              <Grid item xs={8}>
                <TextField
                  id="outlined-required"
                  label="Address Line 2"
                  onChange={(event) => {
                    setPickAddress2(event.target.value);
                  }}
                  fullWidth
                />
              </Grid>
              <Grid item xs={8}>
                <TextField
                  required
                  id="outlined-required"
                  label="City"
                  onChange={(event) => {
                    setPickCity(event.target.value);
                  }}
                  fullWidth
                />
              </Grid>
              <Grid item xs={6}>
                <TextField
                  required
                  id="outlined-required"
                  label="State"
                  onChange={(event) => {
                    setPickState(event.target.value);
                  }}
                  fullWidth
                />
              </Grid>
              <Grid item xs={6}>
                <TextField
                  required
                  id="outlined-required"
                  label="ZIP"
                  onChange={(event) => {
                    setPickZIP(event.target.value);
                  }}
                  fullWidth
                />
              </Grid>
            </Grid>
            {/* end pickup form */}
            <Grid container spacing={1}>
              <Grid item xs={12}>
                <div style={{ marginTop: "20px" }}>
                  <Typography variant="h4">DropOff-Addr</Typography>
                </div>
              </Grid>
              {/* begin pickup address form */}
              <Grid item xs={8}>
                <TextField
                  required
                  id="outlined-required"
                  label="Address Line 1"
                  onChange={(event) => {
                    setDropAddress1(event.target.value);
                  }}
                  fullWidth
                />
              </Grid>
              <Grid item xs={8}>
                <TextField
                  id="outlined-required"
                  label="Address Line 2"
                  onChange={(event) => {
                    setDropAddress2(event.target.value);
                  }}
                  fullWidth
                />
              </Grid>
              <Grid item xs={8}>
                <TextField
                  required
                  id="outlined-required"
                  label="City"
                  onChange={(event) => {
                    setDropCity(event.target.value);
                  }}
                  fullWidth
                />
              </Grid>
              <Grid item xs={6}>
                <TextField
                  required
                  id="outlined-required"
                  label="State"
                  onChange={(event) => {
                    setDropState(event.target.value);
                  }}
                  fullWidth
                />
              </Grid>
              <Grid item xs={6}>
                <TextField
                  required
                  id="outlined-required"
                  label="ZIP"
                  onChange={(event) => {
                    setDropZIP(event.target.value);
                  }}
                  fullWidth
                />
              </Grid>
            </Grid>
          </Grid>
          <Grid item xs={12}>
            <Stack direction="row" justifyContent="center">
              <FormControl sx={{ m: 1, minWidth: 120 }}>
                <InputLabel id="pickup-priority-helper-label">
                  Priority
                </InputLabel>
                <Select
                  labelId="pickup-priority-helper-label"
                  id="pickup-priority-select-helper"
                  value={pickupPriority}
                  label="Priority"
                  onChange={handleChange}
                  required
                >
                  <MenuItem value={0}>
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
                <FormHelperText>
                  Price will be calculated based on distance and priority
                </FormHelperText>
              </FormControl>
            </Stack>
          </Grid>
          <Grid item xs={6}>
            <Button variant="outlined">Delete</Button>
          </Grid>
          <Grid item xs={6}>
            <Stack direction="row" justifyContent="end">
              <Button style={{ marginBottom: "30px" }} variant="contained" onClick={insertDB}>
                Submit
              </Button>
            </Stack>
          </Grid>
        </Grid>
      </LocalizationProvider>
    </div>
  );
};

const noak = "MzlmOWIyNjhiNTY3NDk3MmFhYjQ1NDVlZTNhOGQ3ZDk6MjkwZmQwYTktYzI2NC00ODkzLWFiYjgtMjg3MzE4Y2NkOWYy";

function getCoordinates(address) {
  return fetch("https://api.myptv.com/geocoding/v1/locations/by-text?searchText=" + address, {
        method: "GET",
        headers: { apiKey: noak, "Content-Type": "application/json" },
    })
    .then(response => response.json())
    .then(result => {
      return result.locations[0]["roadAccessPosition"];
    });
}

export default PackageForm;
