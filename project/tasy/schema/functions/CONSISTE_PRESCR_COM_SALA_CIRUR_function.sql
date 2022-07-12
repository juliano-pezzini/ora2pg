-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consiste_prescr_com_sala_cirur ( nr_prescricao_p bigint, nr_SeqUnidAtend_p bigint, nr_evento_saida_sala_p bigint, ie_validar_sala_p text) RETURNS varchar AS $body$
DECLARE


dt_entrada_unidade_w	timestamp;
nr_atendimento_w	bigint;
nr_cirurgia_w		bigint;
nr_seq_interno_w 	bigint := 0;
dt_termino_w		timestamp;


BEGIN

SELECT 	MAX(a.dt_entrada_unidade),
	MAX(a.nr_atendimento),
	MAX(a.nr_cirurgia),
	MAX(a.dt_termino)
into STRICT	dt_entrada_unidade_w,
	nr_atendimento_w,
	nr_cirurgia_w,
	dt_termino_w
FROM 	cirurgia a
WHERE 	a.nr_prescricao = nr_prescricao_p
and 	NOT EXISTS (	SELECT 	1
			FROM 	evento_cirurgia_paciente b
			WHERE 	a.nr_cirurgia = b.nr_cirurgia
			AND 	b.nr_seq_evento = nr_evento_saida_sala_p
			AND 	coalesce(b.dt_inativacao::text, '') = '');

if	((dt_entrada_unidade_w IS NOT NULL AND dt_entrada_unidade_w::text <> '') and (nr_atendimento_w > 0) and (nr_SeqUnidAtend_p IS NOT NULL AND nr_SeqUnidAtend_p::text <> '')) then
	select	coalesce(max(a.nr_seq_interno), 0)
	into STRICT 	nr_seq_interno_w
	from	atend_paciente_unidade a, unidade_atendimento b
	where	a.nr_atendimento 	= nr_atendimento_w
	and	a.dt_entrada_unidade 	= dt_entrada_unidade_w
	and 	b.nr_seq_interno 	= nr_SeqUnidAtend_p
	and 	a.cd_setor_atendimento 	= b.cd_setor_atendimento
	and 	a.cd_unidade_basica 	= b.cd_unidade_basica
	and 	a.cd_unidade_compl 	= b.cd_unidade_compl
	and 	coalesce(dt_saida_unidade::text, '') = '';
end if;

if (nr_seq_interno_w > 0) or ((nr_cirurgia_w > 0) and (coalesce(dt_termino_w::text, '') = '') and (coalesce(nr_SeqUnidAtend_p::text, '') = '')) then
	return 'S';
else
	return 'N';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consiste_prescr_com_sala_cirur ( nr_prescricao_p bigint, nr_SeqUnidAtend_p bigint, nr_evento_saida_sala_p bigint, ie_validar_sala_p text) FROM PUBLIC;

