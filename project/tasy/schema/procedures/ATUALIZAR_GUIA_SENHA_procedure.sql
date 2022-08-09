-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_guia_senha (nr_prescricao_p text, cd_senha_p text, nr_doc_conv_p text) AS $body$
BEGIN

update	prescr_procedimento
set	nr_doc_convenio	  = nr_doc_conv_p,
	cd_senha	  = cd_senha_p
where	nr_prescricao     = nr_prescricao_p;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_guia_senha (nr_prescricao_p text, cd_senha_p text, nr_doc_conv_p text) FROM PUBLIC;
