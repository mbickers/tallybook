import { Modal, ModalOverlay, ModalContent, ModalHeader, ModalBody, VStack, FormControl, FormLabel, Input, RadioGroup, HStack, Radio, ModalFooter, Button } from "@chakra-ui/react";
import { Formik, Field, FieldProps } from "formik";
import { TallyKind } from "../types";

export const EditTallyModal = ({mode, initialValues, isOpen, onConfirm, onClose}: {mode: "Add" | "Edit", initialValues: { name: string, kind: TallyKind }, isOpen: boolean, onConfirm: (name: string, kind: TallyKind) => void, onClose: () => void}) => {
    return (
        <Modal isOpen={isOpen} onClose={onClose}>
            <ModalOverlay />
            <ModalContent>
                <ModalHeader>{mode === "Add" ? "Add a Tally" : "Edit Tally"}</ModalHeader>
                <Formik
                    initialValues={initialValues}
                    onSubmit={({ name, kind }) => {
                        onConfirm(name, kind)
                        onClose()
                    }}
                >
                    {({ handleSubmit }) => (
                        <form onSubmit={handleSubmit} autoComplete='off'>
                            <ModalBody>
                                <VStack spacing={4} align="begin">
                                    <FormControl>
                                        <FormLabel>Name</FormLabel>
                                        <Field
                                            as={Input}
                                            id="name"
                                            name="name"
                                            variant="filled"
                                        />
                                    </FormControl>
                                    <Field name='kind'>
                                        {({ field }: FieldProps) => (
                                            <FormControl>
                                                <RadioGroup {...field} id='kind'>
                                                    <HStack spacing='1rem'>
                                                        {Object.keys(TallyKind).map(value => (
                                                            <Radio key={value} {...field} value={value}>
                                                                {value}
                                                            </Radio>
                                                        ))}
                                                    </HStack>
                                                </RadioGroup>
                                            </FormControl>
                                        )}
                                    </Field>
                                </VStack>
                            </ModalBody>
                            <ModalFooter>
                                <HStack>
                                    <Button variant='ghost' mr='1rem' onClick={onClose}>Cancel</Button>
                                    <Button colorScheme='green' type='submit'>
                                        {mode === "Add" ? "Add Tally" : "Done"}
                                    </Button>
                                </HStack>
                            </ModalFooter>
                        </form>)}
                </Formik>
            </ModalContent>
        </Modal>
    )
}