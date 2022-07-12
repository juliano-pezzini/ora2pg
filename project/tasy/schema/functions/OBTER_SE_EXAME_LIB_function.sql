-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exame_lib ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

qt_exame_w		bigint;
qt_exame_lib_w		bigint;
ds_retorno_w		varchar(1);
ie_aprov_bioquimico_w	varchar(3);
ie_status_atend_w	smallint	:= 35;

/*

P - Exame liberado e pendente por fazer
S - Exame liberado e já feito
N - Não tem exame liberado para o paciente

*/
BEGIN

select	max(coalesce(vl_parametro,vl_parametro_padrao))
into STRICT	ie_aprov_bioquimico_w
from	funcao_parametro
where	cd_funcao	= 281
and	nr_sequencia	= 176;

if (ie_aprov_bioquimico_w = 'S') then
	ie_status_atend_w	:= 30;
end if;

select	count(1)
into STRICT	qt_exame_w
from	prescr_procedimento b,
	prescr_medica a
where	a.nr_prescricao  = b.nr_prescricao
and	a.nr_atendimento = nr_atendimento_p
and (Obter_se_exame_presc_externo(b.cd_procedimento,b.nr_seq_proc_interno) = 'N')
and	(b.nr_seq_exame IS NOT NULL AND b.nr_seq_exame::text <> '')
and ((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> ''))
and   coalesce(b.ie_suspenso, 'N') = 'N'
and   coalesce(b.ie_exame_bloqueado,'N') = 'N';

select	count(1)
into STRICT	qt_exame_lib_w
from	prescr_procedimento b,
	prescr_medica a
where	a.nr_prescricao  = b.nr_prescricao
and	a.nr_atendimento = nr_atendimento_p
and (Obter_se_exame_presc_externo(b.cd_procedimento,b.nr_seq_proc_interno) = 'N')
and	b.ie_status_atend >= ie_status_atend_w
and	(b.nr_seq_exame IS NOT NULL AND b.nr_seq_exame::text <> '')
and ((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> ''))
and   coalesce(b.ie_suspenso, 'N') = 'N'
and   coalesce(b.ie_exame_bloqueado,'N') = 'N';

if (qt_exame_lib_w < qt_exame_w ) and ( qt_exame_lib_w <> 0 ) then
	ds_retorno_w := 'P';
else
if ( qt_exame_lib_w = qt_exame_w) and (qt_exame_w <> 0) then
	ds_retorno_w := 'S';
else
	ds_retorno_w := 'N';
end if;
end if;

RETURN	ds_retorno_w;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exame_lib ( nr_atendimento_p bigint) FROM PUBLIC;

