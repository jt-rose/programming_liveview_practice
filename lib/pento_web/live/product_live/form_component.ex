defmodule PentoWeb.ProductLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.Catalog

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Catalog.change_product(product)
    Process.sleep(250)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:image,
      accept: ~w(.jpg .jpeg .png),
      max_entries: 1,
      max_file_size: 9_000_000,
      auto_upload: true,
      progress: &handle_progress/3
      )}
  end

  defp handle_progress(:image, entry, socket) do
    :timer.sleep(200)
    if entry.done? do
      # {:ok, path} =
        result =
        consume_uploaded_entry(
          socket,
          entry,
          &upload_static_file(&1, socket)
        )
        IO.puts result
        {:noreply, socket
          |> put_flash(:info, "file #{entry.client_name} uploaded")
          |> assign(:image_upload, result)}
      else
        {:noreply, socket}
    end
  end

  defp upload_static_file(%{path: path}, socket) do
    # add your prod image host integration, ie S3 bucket
    dest = Path.join("priv/static/images", Path.basename(path))
    File.cp!(path, dest)
    {:ok, Routes.static_path(socket, "/images/#{Path.basename(dest)}")}
  end

  def upload_image_error(%{image: %{ errors: errors}}, entry) when length(errors) > 0 do
    {_, msg} =
      Enum.find(errors, fn {ref, _} -> ref == entry.ref || ref == entry.upload_ref

      end)
      upload_error_msg(msg)
  end

  def upload_image_error(_, _), do: ""
defp upload_error_msg(:not_accepted) do "Invalid file type"
end
defp upload_error_msg(:too_many_files) do "Too many files"
end
defp upload_error_msg(:too_large) do "File exceeds max size"
end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Catalog.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  def add_image_upload(socket, params) do
    Map.put(params, "image_upload", socket.assigns.image_upload)
  end

  defp save_product(socket, :edit, params) do
    result = Catalog.update_product(socket.assigns.product, add_image_upload(socket, params))
    case result do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product(socket, :new, params) do
    case Catalog.create_product(add_image_upload(socket, params)) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
