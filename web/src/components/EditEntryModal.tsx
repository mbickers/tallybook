import { Modal, ModalOverlay, ModalContent, ModalHeader, ModalBody, VStack, FormControl, FormLabel, Input, RadioGroup, HStack, Radio, ModalFooter, Button, NumberInput, NumberInputField } from "@chakra-ui/react";
import { Formik, Field, FieldProps } from "formik";
import { TallyEntry, TallyKind } from "../types";
import { formattedDate } from "../utils";

export const EditEntryModal = ({mode, initialValues, isOpen, onConfirm, onClose}: {mode: "Add" | "Edit", initialValues: TallyEntry, isOpen: boolean, onConfirm: (updatedEntry: TallyEntry) => void, onClose: () => void}) => {
    return (
        <Modal isOpen={isOpen} onClose={onClose}>
            <ModalOverlay />
            <ModalContent>
                <ModalHeader>{mode === "Add" ? "Add an Entry" : "Edit Entry"}</ModalHeader>
                <Formik
                    initialValues={initialValues}
                    onSubmit={(updatedEntry) => {
                        onConfirm(updatedEntry)
                        onClose()
                    }}
                >
                    {({ handleSubmit }) => (
                        <form onSubmit={handleSubmit} autoComplete='off'>
                            <ModalBody>
                                <HStack>
                                    <Field type='date' name='formattedDate' as={Input} max={formattedDate(new Date())} />
                                    <Field name='value'>
                                        {({ field, form }: FieldProps) => {
                                            return (
                                                <NumberInput id='value' {...field} onChange={val => form.setFieldValue(field.name, Number(val))}>
                                                    <NumberInputField />
                                                </NumberInput>
                                            )
                                        }}
                                    </Field>
                                </HStack>
                            </ModalBody>
                            <ModalFooter>
                                <HStack>
                                    <Button variant='ghost' mr='1rem' onClick={onClose}>Cancel</Button>
                                    <Button colorScheme='green' type='submit'>
                                        {mode === "Add" ? "Add Entry" : "Done"}
                                    </Button>
                                </HStack>
                            </ModalFooter>
                        </form>)}
                </Formik>
            </ModalContent>
        </Modal>
    )
}