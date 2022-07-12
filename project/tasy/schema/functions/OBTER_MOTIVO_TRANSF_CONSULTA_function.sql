-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_motivo_transf_consulta (nr_seq_agenda_p bigint, nr_seq_motivo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_motivo_obs_w	varchar(255);
ds_motivo_cad_w	varchar(255);
ds_motivo_w		varchar(2000);
ds_responsavel_w	varchar(40);


BEGIN
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then
	/* obter motivo observacao */

	select	max(ds_motivo_copia_trans),
		'(' || max(nm_usuario_copia_trans) || ' em ' || to_char(max(dt_copia_trans),'dd/mm/yyyy hh24:mi:ss') || ')'
	into STRICT	ds_motivo_obs_w,
		ds_responsavel_w
	from	agenda_consulta
	where	nr_sequencia = nr_seq_agenda_p;

	/* obter motivo cadastro */

	select	max(ds_motivo)
	into STRICT	ds_motivo_cad_w
	from	agenda_motivo
	where	nr_sequencia = nr_seq_motivo_p;

	if (ds_motivo_obs_w IS NOT NULL AND ds_motivo_obs_w::text <> '') and (ds_motivo_cad_w IS NOT NULL AND ds_motivo_cad_w::text <> '') then
		ds_motivo_w := substr(ds_motivo_obs_w || ' - ' || ds_motivo_cad_w|| ' ' || ds_responsavel_w,1,255);
	else
		ds_motivo_w := substr(coalesce(ds_motivo_obs_w, ds_motivo_cad_w|| ' ' || ds_responsavel_w),1,255);
	end if;
end if;

return ds_motivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_motivo_transf_consulta (nr_seq_agenda_p bigint, nr_seq_motivo_p bigint) FROM PUBLIC;

