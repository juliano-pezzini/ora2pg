-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_horario_agenda (nr_seq_agenda bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(50) := '';

ds_hora_w			varchar(20);
ds_lbl_duracao_w	varchar(100);
qt_duracao_w		agenda_consulta.nr_minuto_duracao%type;
ds_lbl_min_w		varchar(100);



BEGIN

if (nr_seq_agenda IS NOT NULL AND nr_seq_agenda::text <> '') then
	select	pkg_date_formaters.to_varchar(DT_AGENDA, 'shortTime', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario) ds_hora,
			obter_desc_expressao(343783) ds_lbl_duracao,
			nr_minuto_duracao qt_duracao,
			obter_desc_expressao(305063)
	into STRICT	ds_hora_w,
			ds_lbl_duracao_w,
			qt_duracao_w,
			ds_lbl_min_w
	from	agenda_consulta
	where	nr_sequencia = nr_seq_agenda;

	ds_retorno_w := ds_hora_w || ' - ' || ds_lbl_duracao_w || qt_duracao_w || ' ' || ds_lbl_min_w;
end if;

return substr(ds_retorno_w,0,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_horario_agenda (nr_seq_agenda bigint) FROM PUBLIC;
