import React, { useState, useEffect } from "react";
import { makeStyles } from "@material-ui/core/styles";

import ModalImage from "react-modal-image";
import api from "../../services/api";

const useStyles = makeStyles(theme => ({
	messageMedia: {
		objectFit: "cover",
		width: 250,
		height: 200,
		borderTopLeftRadius: 8,
		borderTopRightRadius: 8,
		borderBottomLeftRadius: 8,
		borderBottomRightRadius: 8,
	},
}));

const ModalImageCors = ({ imageUrl }) => {
	const classes = useStyles();
	const [fetching, setFetching] = useState(true);
	const [blobUrl, setBlobUrl] = useState("");

	useEffect(() => {
		if (!imageUrl) return;
		const fetchImage = async () => {
			try {
				const { data, headers } = await api.get(imageUrl, {
					responseType: "blob",
				});
				const url = window.URL.createObjectURL(
					new Blob([data], { type: headers["content-type"] })
				);
				setBlobUrl(url);
				setFetching(false);
			} catch (err) {
				// Se o fetch via API falhar, usa a URL direta como fallback
				console.warn("[ModalImageCors] Fetch via API falhou, usando URL direta:", err?.message || err);
				setFetching(false);
			}
		};
		fetchImage();
	}, [imageUrl]);

	if (!imageUrl) return null;

	return (
		<ModalImage
			className={classes.messageMedia}
			smallSrcSet={fetching ? imageUrl : (blobUrl || imageUrl)}
			medium={fetching ? imageUrl : (blobUrl || imageUrl)}
			large={fetching ? imageUrl : (blobUrl || imageUrl)}
			alt="image"
		/>
	);
};

export default ModalImageCors;
