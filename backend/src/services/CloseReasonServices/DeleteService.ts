import ShowService from "./ShowService";

const DeleteService = async (
  id: string | number,
  companyId: number
): Promise<void> => {
  const reason = await ShowService(id, companyId);
  await reason.destroy();
};

export default DeleteService;
