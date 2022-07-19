-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_lib_autorizacao ( nr_seq_guia_p bigint, ds_mensagem_proc_p INOUT text, ds_mensagem_mat_p INOUT text, ds_mensagem_glosa_p INOUT text) AS $body$
DECLARE


qt_guia_proc_w		bigint;
qt_guia_mat_w		bigint;
qt_guia_glosa_w		bigint;
ds_mensagem_proc_w	varchar(255);
ds_mensagem_mat_w	varchar(255);
ds_mensagem_glosa_w	varchar(255);


BEGIN

if (nr_seq_guia_p > 0) then
	begin
	select	count(*)
	into STRICT	qt_guia_proc_w
	from	pls_guia_plano_proc
	where	nr_seq_guia	= nr_seq_guia_p
	and	coalesce(nr_seq_motivo_exc::text, '') = ''
	and	ie_status	= 'N';

	if (qt_guia_proc_w > 0) then
		ds_mensagem_proc_w	:= substr(obter_texto_tasy(38671, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	end if;

	select	count(*)
	into STRICT	qt_guia_mat_w
	from	pls_guia_plano_mat
	where	nr_seq_guia	= nr_seq_guia_p
	and	coalesce(nr_seq_motivo_exc::text, '') = ''
	and	ie_status	= 'N';

	if (qt_guia_mat_w > 0) then
		ds_mensagem_mat_w	:= substr(obter_texto_tasy(38672, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	end if;

	select	count(*)
	into STRICT	qt_guia_glosa_w
	from	pls_guia_glosa
	where	nr_seq_guia	= nr_seq_guia_p;

	if (qt_guia_glosa_w > 0) then
		ds_mensagem_glosa_w	:= substr(obter_texto_tasy(38673, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	end if;
	end;
end if;

ds_mensagem_proc_p	:= ds_mensagem_proc_w;
ds_mensagem_mat_p	:= ds_mensagem_mat_w;
ds_mensagem_glosa_p	:= ds_mensagem_glosa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_lib_autorizacao ( nr_seq_guia_p bigint, ds_mensagem_proc_p INOUT text, ds_mensagem_mat_p INOUT text, ds_mensagem_glosa_p INOUT text) FROM PUBLIC;

