import "../styles/globals.css";
import React from "react";
import PackageForm from "./PackageForm";
import Container from "@mui/material/Container";
import Typography from "@mui/material/Typography";

function MyApp({ Component, pageProps }) {
  return (
    <Container maxWidth="sm">
      <PackageForm />
    </Container>
  );
}

export default MyApp;
