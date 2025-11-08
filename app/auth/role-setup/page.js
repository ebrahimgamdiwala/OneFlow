"use client";

import { useState, useEffect } from "react";
import { useSession } from "next-auth/react";
import { useRouter } from "next/navigation";
import RoleSelectionModal from "@/components/RoleSelectionModal";

export default function RoleSetupPage() {
  const { data: session, status, update } = useSession();
  const router = useRouter();
  const [showModal, setShowModal] = useState(false);

  useEffect(() => {
    if (status === "unauthenticated") {
      router.push("/login");
    } else if (status === "authenticated") {
      // Check if user has a role set
      if (!session?.user?.role || session.user.role === "TEAM_MEMBER") {
        setShowModal(true);
      } else {
        // User already has a role, redirect to dashboard
        router.push("/dashboard");
      }
    }
  }, [status, session, router]);

  const handleClose = async () => {
    setShowModal(false);
    // Update the session
    await update();
    router.push("/dashboard");
  };

  if (status === "loading") {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen flex items-center justify-center">
      <RoleSelectionModal
        isOpen={showModal}
        onClose={handleClose}
        userEmail={session?.user?.email}
        userName={session?.user?.name}
      />
    </div>
  );
}
