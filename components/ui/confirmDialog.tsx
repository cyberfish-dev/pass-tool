import * as React from "react";
import {
  Dialog,
  DialogTrigger,
  DialogContent,
  DialogDescription,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { DialogTitle } from "@radix-ui/react-dialog";

interface ConfirmDialogProps {
  title?: string;
  message?: string;
  confirmText?: string;
  cancelText?: string;
  onConfirm: () => void;
  children: React.ReactNode;
}

export function ConfirmDialog({
  children,
  title = "Are you sure?",
  message = "This action cannot be undone.",
  confirmText = "Delete",
  cancelText = "Cancel",
  onConfirm,
}: ConfirmDialogProps) {
  const [open, setOpen] = React.useState(false);

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <span onClick={() => setOpen(true)}>{children}</span>
      </DialogTrigger>
      <DialogContent className="max-w-sm space-y-4">
        <DialogTitle>{title}</DialogTitle>
        <DialogDescription>{message}</DialogDescription>
        {/*       
        <p className="text-sm text-muted-foreground" id="confirm-dialog-description">{message}</p> */}
        <div className="flex justify-end gap-2">
          <Button onClick={() => setOpen(false)}>{cancelText}</Button>
          <Button
            className="btn-danger"
            onClick={() => {
              onConfirm();
              setOpen(false);
            }}
          >
            {confirmText}
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}
