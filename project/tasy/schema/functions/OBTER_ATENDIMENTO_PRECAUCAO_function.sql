-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_atendimento_precaucao ( nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_precaucao_w		bigint;
ds_precaucao_w			varchar(100);
nr_seq_atend_precaucao_w	bigint;
dt_inicio_w			timestamp;
dt_termino_w			timestamp;
ds_motivo_isolamento_w		varchar(255);


BEGIN

select	coalesce(max(nr_Sequencia),0)
into STRICT	nr_seq_atend_precaucao_w
from	atendimento_precaucao
where	nr_atendimento = nr_atendimento_p
and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
and	coalesce(dt_inativacao::text, '') = ''
and	coalesce(dt_final_precaucao, clock_timestamp() + interval '1 days') > clock_timestamp();


if (nr_seq_atend_precaucao_w > 0) then

	select  nr_seq_precaucao,
		dt_inicio,
		dt_termino,
		coalesce(obter_descricao_padrao('MOTIVO_ISOLAMENTO','DS_MOTIVO',NR_SEQ_MOTIVO_ISOL), obter_descricao_padrao('CIH_PRECAUCAO','DS_PRECAUCAO',NR_SEQ_PRECAUCAO))
	into STRICT	nr_seq_precaucao_w,
		dt_inicio_w,
		dt_termino_w,
		ds_motivo_isolamento_w
	from	atendimento_precaucao
	where	nr_sequencia = nr_seq_atend_precaucao_w;

	select  ds_precaucao
	into STRICT	ds_precaucao_w
	from	cih_precaucao
	where	nr_sequencia = nr_seq_precaucao_w;
end if;

if (upper(ie_opcao_p) = 'C') then
	return	nr_seq_precaucao_w;
elsif (upper(ie_opcao_p) = 'I') then
	return	PKG_DATE_FORMATERS.TO_VARCHAR(dt_inicio_w,'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, WHEB_USUARIO_PCK.get_nm_usuario);
elsif (upper(ie_opcao_p) = 'T') then
	return 	PKG_DATE_FORMATERS.TO_VARCHAR(dt_termino_w,'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, WHEB_USUARIO_PCK.get_nm_usuario);
elsif (upper(ie_opcao_p) = 'M') then
	return	ds_motivo_isolamento_w;
else
	return ds_precaucao_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_atendimento_precaucao ( nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;
