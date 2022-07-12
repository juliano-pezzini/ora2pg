-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_permanencia_unif ( nr_atendimento_p bigint, nr_interno_conta_p bigint, ie_opcao_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w		bigint;
dt_entrada_w		timestamp;
dt_alta_w		timestamp;
qt_diarias_w		bigint	:= 0;
cd_procedimento_real_w	bigint;
ie_origem_proc_real_w	bigint;
ie_permanencia_w	varchar(1)	:= 'N';
qt_permanencia_w	bigint	:= 0;
qt_diarias_uti_w	bigint	:= 0;
qt_longa_perm_total_w	bigint	:= 0;
qt_longa_perm_liq_w	bigint	:= 0;
cd_procedimento_w	bigint;
dt_emissao_w 		sus_aih_unif.dt_emissao%type;
dt_inicial_w			sus_aih_unif.dt_inicial%type;

/*Opções:
1 - Permanência do procedimento no SUS
2 - Permanência real do atendimento
3 - Quantidade de longa permanência
*/
c01 CURSOR FOR
	SELECT 	cd_procedimento
	from	procedimento_paciente
	where	nr_interno_conta	= nr_interno_conta_p
	and	coalesce(cd_motivo_Exc_conta::text, '') = ''
	and	Sus_Obter_TipoReg_Proc(cd_procedimento,ie_origem_proced,'C',13) = 3
	order by obter_qt_dia_internacao_sus(cd_procedimento, ie_origem_proced);



BEGIN

/* Obter dados da AIH */

begin
select	cd_procedimento_real,
	ie_origem_proc_real,
	dt_inicial
into STRICT	cd_procedimento_real_w,
	ie_origem_proc_real_w,
	dt_inicial_w
from	sus_aih_unif
where	nr_atendimento		= nr_atendimento_p
and	nr_interno_conta	= nr_interno_conta_p;
exception
	when others then
	cd_procedimento_real_w	:= 0;
	ie_origem_proc_real_w	:= 0;
	dt_inicial_w		:= null;
end;
	/*Nos casos de Cirurgia Mltipla, Politraumatizado, Tratamento da AIDS, Procedimentos Seqenciais de
	Coluna em Ortopedia e/ou Neurocirurgia e Cirurgia Plstica Corretiva ps Gastroplastia, para fins de clculo de
	permanncia deve-se utilizar como parmetro a mdia de permanncia do procedimento de maior nmero de dias, entre
	os registrados no SISAIH01, na tela Procedimentos Realizados.*/
if (Sus_Validar_Regra(nr_seq_regra_p => 11,cd_procedimento_p => cd_procedimento_real_w,ie_origem_proced_p => ie_origem_proc_real_w,dt_competencia_p => dt_inicial_w) >0) then
	open C01;
	loop
	fetch C01 into	
		cd_procedimento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;
	
	if (coalesce(cd_procedimento_w,0)	<> 0) then
		cd_procedimento_real_w		:= cd_procedimento_w;
	end if;
end if;

/* Obter dados do procedimento */

begin
select	ie_permanencia,
	obter_qt_dia_internacao_sus(cd_procedimento, ie_origem_proced)
into STRICT	ie_permanencia_w,
	qt_permanencia_w
from	sus_procedimento
where	cd_procedimento		= cd_procedimento_real_w
and	ie_origem_proced	= ie_origem_proc_real_w;
exception
	when others then
	ie_permanencia_w	:= 'N';
end;

/* Selecao das datas de entrada e alta do Paciente */

begin
select	coalesce(a.dt_inicial,b.dt_entrada),
	coalesce(a.dt_final,coalesce(b.dt_alta,clock_timestamp())),
	a.dt_emissao
into STRICT	dt_entrada_w,
	dt_alta_w,
	dt_emissao_w
from	atendimento_paciente	b,
	sus_aih_unif		a
where	a.nr_atendimento	= nr_atendimento_p
and	a.nr_interno_conta	= nr_interno_conta_p
and	a.nr_atendimento	= b.nr_atendimento;
exception
	when others then
	begin
	Select	dt_entrada,
		coalesce(dt_alta,clock_timestamp())
	into STRICT	dt_entrada_w,
		dt_alta_w
	from 	atendimento_paciente
	where	nr_atendimento	= nr_atendimento_p;
	end;
end;

/* Identificar se tem permanencia para o procedimento realizado */

qt_diarias_w	:= (trunc(dt_alta_w) - trunc(dt_entrada_w));

/* Procedimentos de diaria de UTI */
select	coalesce(sum(qt_procedimento),0)
into STRICT	qt_diarias_uti_w
from	procedimento_paciente
where 	nr_atendimento		= nr_atendimento_p
and	nr_interno_conta	= nr_interno_conta_p
and	ie_origem_Proced	= 7
and	coalesce(cd_motivo_exc_conta::text, '') = ''
and	((sus_validar_regra(7, cd_procedimento, ie_origem_proced, dt_procedimento) > 0) or (sus_validar_regra( 13, cd_procedimento, ie_origem_proced, dt_procedimento) > 0));

/* Calculo da Longa Permanencia */
begin
if (qt_diarias_w > 0) and (qt_permanencia_w > 0) and (Sus_Obter_Se_Detalhe_Proc(cd_procedimento_real_w, ie_origem_proc_real_w,'004',dt_emissao_w) > 0) and (cd_procedimento_real_w IS NOT NULL AND cd_procedimento_real_w::text <> '') then
	begin
	qt_permanencia_w		:= (qt_permanencia_w * 2);
	qt_longa_perm_total_w		:= qt_diarias_w - qt_permanencia_w;
	qt_longa_perm_liq_w		:= qt_longa_perm_total_w - qt_diarias_uti_w;
	if (qt_longa_perm_liq_w) < 0 then
		qt_longa_perm_liq_w	:= 0;
	end if;

	if (ie_opcao_p = 1) then
		ds_retorno_w := qt_permanencia_w;
	elsif (ie_opcao_p = 2) then	
		ds_retorno_w := qt_diarias_w;
	elsif (ie_opcao_p = 3) then	
		ds_retorno_w := qt_longa_perm_liq_w;
	end if;
	end;
end if;
end;

return	coalesce(ds_retorno_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_permanencia_unif ( nr_atendimento_p bigint, nr_interno_conta_p bigint, ie_opcao_p bigint) FROM PUBLIC;
