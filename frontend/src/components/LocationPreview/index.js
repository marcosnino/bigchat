import React, { useEffect } from 'react';
import toastError from "../../errors/toastError";

import { Button, Divider, Typography} from "@material-ui/core";
import { i18n } from '../../translate/i18n';

const LocationPreview = ({ image, link, description }) => {
    useEffect(() => {}, [image, link, description]);

    const handleLocation = async() => {
        try {
            window.open(link);
        } catch (err) {
            toastError(err);
        }
    }

    return (
		<>
			<div style={{
				minWidth: "250px",
			}}>
				<div>
					<div style={{ float: "left", cursor: "pointer" }} onClick={handleLocation}>
						{image ? (
							<img src={image} alt="loc" style={{ width: "100px" }} />
						) : (
							<div style={{
								width: "100px",
								height: "100px",
								backgroundColor: "#e8f5e9",
								display: "flex",
								alignItems: "center",
								justifyContent: "center",
								borderRadius: "8px",
								fontSize: "40px",
							}}>
								📍
							</div>
						)}
					</div>
					{ description && (
					<div style={{ display: "flex", flexWrap: "wrap" }}>
						<Typography style={{ marginTop: "12px", marginLeft: "15px", marginRight: "15px", float: "left" }} variant="subtitle1" color="primary" gutterBottom>
							{description}
						</Typography>
					</div>
					)}
					<div style={{ display: "block", content: "", clear: "both" }}></div>
					<div>
						<Divider />
						<Button
							fullWidth
							color="primary"
							onClick={handleLocation}
							disabled={!link}
						>
							{i18n.t("locationPreview.button")}
						</Button>
					</div>
				</div>
			</div>
		</>
	);

};

export default LocationPreview;