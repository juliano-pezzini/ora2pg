-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_diferenca_peso_quimio ( nr_seq_paciente_p bigint, nr_atendimento_p bigint, ie_momento_p text, nr_seq_atendimento_p bigint, qt_diferenca_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(10);
qt_peso_trat_w	double precision;
qt_peso_sv_w	double precision;
qt_dif_maior_w	double precision;
qt_dif_menor_w	double precision;
cd_pessoa_fisica_w varchar(10);


BEGIN

ds_retorno_w := 'S';

select	max(cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from	paciente_setor
where	nr_seq_paciente = nr_seq_paciente_p;

if (coalesce(nr_atendimento_p,0) > 0) then
	select	coalesce(max(qt_peso),0)
	into STRICT	qt_peso_sv_w
	from	atendimento_sinal_vital
	where	nr_atendimento = nr_atendimento_p
	and	nr_sequencia = (SELECT max(nr_sequencia)
				from atendimento_sinal_vital
				where nr_atendimento = nr_atendimento_p
				and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> ''));

elsif (coalesce(cd_pessoa_fisica_w,'XPTO') <> 'XPTO') then
	select	coalesce(max(qt_peso),0)
	into STRICT	qt_peso_sv_w
	from	atendimento_sinal_vital
	where	cd_paciente = cd_pessoa_fisica_w
	and	nr_sequencia = (SELECT max(nr_sequencia)
				from atendimento_sinal_vital
				where cd_paciente = cd_pessoa_fisica_w
				and  (dt_liberacao IS NOT NULL AND dt_liberacao::text <> ''));
end if;

if (ie_momento_p = 'FT') then
	select	coalesce(max(qt_peso),0)
	into STRICT	qt_peso_trat_w
	from	paciente_setor
	where	nr_seq_paciente = nr_seq_paciente_p;

elsif (ie_momento_p = 'GP') then
	select	coalesce(max(qt_peso),0)
	into STRICT	qt_peso_trat_w
	from	paciente_atendimento
	where	nr_seq_paciente = nr_seq_paciente_p
	and	nr_seq_atendimento = nr_seq_atendimento_p;
end if;


qt_dif_maior_w	:= (qt_peso_trat_w + (dividir(qt_diferenca_p,100) * qt_peso_trat_w));
qt_dif_menor_w	:= (qt_peso_trat_w - (dividir(qt_diferenca_p,100) * qt_peso_trat_w));

if 	(qt_peso_sv_w > qt_dif_menor_w AND qt_peso_sv_w < qt_dif_maior_w) then
	ds_retorno_w := 'N';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_diferenca_peso_quimio ( nr_seq_paciente_p bigint, nr_atendimento_p bigint, ie_momento_p text, nr_seq_atendimento_p bigint, qt_diferenca_p bigint) FROM PUBLIC;

