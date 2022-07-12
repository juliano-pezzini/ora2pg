-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_motivo_bloq_agenda (nr_seq_agenda_p bigint, nr_seq_motivo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_motivo_obs_w	varchar(255);
ds_motivo_cad_w	varchar(255);
ds_motivo_w		varchar(255);
ds_responsavel_w	varchar(40);


BEGIN
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then
	/* obter motivo observacao */

	select	max(ds_motivo_status),
		CASE WHEN max(nm_usuario_bloq)='' THEN  ''  ELSE '(' || max(nm_usuario_bloq) || chr(32) || wheb_mensagem_pck.get_texto(456028) || chr(32) || PKG_DATE_FORMATERS.TO_VARCHAR(max(dt_bloqueio), 'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, WHEB_USUARIO_PCK.GET_NM_USUARIO) || ')' END
	into STRICT	ds_motivo_obs_w,
		ds_responsavel_w
	from	agenda_paciente
	where	nr_sequencia = nr_seq_agenda_p;

	/* obter motivo cadastro */

	select	max(ds_motivo)
	into STRICT	ds_motivo_cad_w
	from	agenda_motivo
	where	nr_sequencia = nr_seq_motivo_p;

	if (ds_motivo_obs_w IS NOT NULL AND ds_motivo_obs_w::text <> '') and (ds_motivo_cad_w IS NOT NULL AND ds_motivo_cad_w::text <> '') then
		ds_motivo_w := substr(ds_motivo_obs_w || ' - ' || ds_motivo_cad_w || ' ' || ds_responsavel_w ,1,255);
	else
		ds_motivo_w := substr(coalesce(ds_motivo_obs_w, ds_motivo_cad_w) || ' ' || ds_responsavel_w,1,255);
	end if;
end if;

return ds_motivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_motivo_bloq_agenda (nr_seq_agenda_p bigint, nr_seq_motivo_p bigint) FROM PUBLIC;

