-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_controle_prescr_eup_js ( nr_prescricao_p bigint, nr_seq_prescr_p bigint default 0, nr_controle_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL, ds_msg_abort_p INOUT text DEFAULT NULL) AS $body$
DECLARE

ds_msg_abort_w			varchar(255);
ie_agrupa_ficha_fleury_w	varchar(1);
nr_seq_prescr_w			integer;


BEGIN

if (coalesce(nr_controle_p::text, '') = '') then
	begin
	ds_msg_abort_w := substr(obter_texto_tasy(104036, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	goto final;
	end;
end if;

select 	coalesce(max(ie_agrupa_ficha_fleury),'N')
into STRICT	ie_agrupa_ficha_fleury_w
from 	lab_parametro a
where 	a.cd_estabelecimento = obter_estabelecimento_ativo;

nr_seq_prescr_w	:= 0;
if (ie_agrupa_ficha_fleury_w <> 'N') then
	nr_seq_prescr_w	:= nr_seq_prescr_p;
end if;

CALL atualizar_controle_prescr_eup(nr_prescricao_p, nr_seq_prescr_w, nr_controle_p, nm_usuario_p);

<<final>>
ds_msg_abort_p	:= ds_msg_abort_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_controle_prescr_eup_js ( nr_prescricao_p bigint, nr_seq_prescr_p bigint default 0, nr_controle_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL, ds_msg_abort_p INOUT text DEFAULT NULL) FROM PUBLIC;
