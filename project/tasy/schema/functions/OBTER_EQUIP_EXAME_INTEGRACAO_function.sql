-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_equip_exame_integracao ( cd_exame_equip_p text, ds_sigla_p text, ie_opcao_p bigint, nr_prescricao_p bigint default null) RETURNS varchar AS $body$
DECLARE

/*
	1 - Exame
	2 - Equipamento
*/
cd_equipamento_w	integer;
nr_seq_exame_w		bigint;
resultado_w		varchar(20);
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
cd_setor_atendimento_w	setor_atendimento.cd_setor_atendimento%type;


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	select	max(a.cd_estabelecimento),
		max(a.cd_setor_atendimento)
	into STRICT	cd_estabelecimento_w,
		cd_setor_atendimento_w
	from	prescr_medica a
	where	a.nr_prescricao = coalesce(nr_prescricao_p,0);
end if;

select 	coalesce(max(a.nr_seq_exame),null),
	coalesce(max(a.cd_equipamento),null)
into STRICT	nr_seq_exame_w,
	cd_equipamento_w
FROM equipamento_lab b, lab_exame_equip a
LEFT OUTER JOIN exame_lab_equip_regra c ON (a.nr_sequencia = c.nr_seq_exame_equip)
WHERE a.cd_equipamento = b.cd_equipamento  and a.cd_exame_equip = cd_exame_equip_p and b.ds_sigla	 = ds_sigla_p and (c.cd_estabelecimento	= coalesce(cd_estabelecimento_w,c.cd_estabelecimento) or coalesce(c.cd_estabelecimento::text, '') = '') and (c.cd_setor_atendimento	= coalesce(cd_setor_atendimento_w,c.cd_setor_atendimento) or coalesce(c.cd_setor_atendimento::text, '') = '');

if (ie_opcao_p = 1) then
	resultado_w := nr_seq_exame_w;
elsif (ie_opcao_p = 2) then
	resultado_w := cd_equipamento_w;

end if;

RETURN resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_equip_exame_integracao ( cd_exame_equip_p text, ds_sigla_p text, ie_opcao_p bigint, nr_prescricao_p bigint default null) FROM PUBLIC;

