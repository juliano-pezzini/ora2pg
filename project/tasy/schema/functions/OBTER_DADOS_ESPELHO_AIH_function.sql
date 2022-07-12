-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_espelho_aih (nr_sequencia_p bigint, nr_seq_participante_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



/*ie_opcao_p
CPF - CPF do profissional executante
CBO - CBO do profissional executante
*/
nr_sequencia_w			bigint;
nr_cpf_executor_w			varchar(11);
nr_cns_executor_w			varchar(15);
cd_cbo_executor_w		varchar(6);
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
ds_retorno_w			varchar(25);
nr_seq_regra_w			bigint;
ie_exclui_medico_w			varchar(1)	:= 'N';
ie_exclui_cnes_w			varchar(1)	:= 'N';
cd_grupo_w			smallint;
qt_registros_w			integer	:= 0;
cd_cgc_prestador_w		varchar(14);
cd_cgc_estab_w			varchar(14);
cd_cgc_prestador_ww		varchar(14);
cd_pessoa_fisica_w		varchar(10);
cd_profissional_w			varchar(10);
cd_medico_executor_w		varchar(10);
ie_credenciamento_w		varchar(3);
cd_estabelecimento_w		smallint;
ie_doc_executor_w			smallint;
cd_cnes_w			varchar(7);
cd_cnes_prestador_w		varchar(7);
ie_doc_prestador_w		smallint	:= 0;
cd_doc_executor_w		varchar(15);
cd_codigo_executor_w		varchar(15);
ie_tipo_servico_w			smallint;
cd_convenio_w			bigint;
ie_exclui_procedimento_w 		varchar(1);
ie_exporta_cnes_w			varchar(1)	:= 'N';
ie_exporta_cnes_hosp_w		varchar(1)	:= 'N';
ie_exporta_cnes_setor_w		varchar(1)	:= 'N';
cd_setor_atendimento_w		integer;
dt_procedimento_w		timestamp;

c01 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced,
		nr_sequencia,
		coalesce(substr(obter_dados_pf(coalesce(cd_medico_executor, cd_pessoa_fisica),'CPF'),1,11),0),
		coalesce(substr(obter_dados_pf(coalesce(cd_medico_executor, cd_pessoa_fisica),'CNS'),1,15),0),		
		dt_procedimento,
		coalesce(cd_cbo, coalesce(sus_obter_cbo_medico(coalesce(cd_medico_executor,cd_pessoa_fisica), cd_procedimento, dt_procedimento, 0),'0')),
		cd_cgc_prestador,
		cd_medico_executor,
		cd_pessoa_fisica,
		ie_doc_executor,
		cd_convenio,
		cd_setor_atendimento
	from	procedimento_paciente
	where	nr_sequencia		= nr_sequencia_p
	and	coalesce(nr_seq_participante_p::text, '') = ''
	
union

	SELECT	a.cd_procedimento,
		a.ie_origem_proced,
		a.nr_sequencia,
		coalesce(substr(obter_dados_pf(b.cd_pessoa_fisica,'CPF'),1,11),0),
		coalesce(substr(obter_dados_pf(b.cd_pessoa_fisica,'CNS'),1,15),0),
		a.dt_procedimento,
		coalesce(b.cd_cbo, coalesce(sus_obter_cbo_medico(b.cd_pessoa_fisica, a.cd_procedimento, a.dt_procedimento, coalesce(sus_obter_indicador_equipe(b.ie_funcao),0)),'0')),
		coalesce(b.cd_cgc,a.cd_cgc_prestador),
		b.cd_pessoa_fisica,
		null,
		b.ie_doc_executor,
		cd_convenio,
		a.cd_setor_atendimento
	from	procedimento_participante	b,
		procedimento_paciente	a
	where	a.nr_sequencia		= b.nr_sequencia
	and	a.nr_sequencia		= nr_sequencia_p
	and	b.nr_seq_partic		= nr_seq_participante_p;


BEGIN

cd_estabelecimento_w := coalesce(wheb_usuario_pck.get_cd_estabelecimento,0);

open c01;
loop
fetch c01 into
	cd_procedimento_w,
	ie_origem_proced_w,
	nr_sequencia_w,
	nr_cpf_executor_w,
	nr_cns_executor_w,
	dt_procedimento_w,
	cd_cbo_executor_w,
	cd_cgc_prestador_w,
	cd_medico_executor_w,
	cd_pessoa_fisica_w,
	ie_doc_executor_w,
	cd_convenio_w,
	cd_setor_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

cd_codigo_executor_w	:= coalesce(cd_medico_executor_w,cd_pessoa_fisica_w);
begin
select	coalesce(cd_cgc,'0')
into STRICT	cd_cgc_estab_w
from 	estabelecimento
where	cd_estabelecimento	= cd_estabelecimento_w  LIMIT 1;
exception
when others then
	cd_cgc_estab_w	:= '0';
end;

select	coalesce(max(substr(lpad(cd_cnes_hospital,7,'0'),1,7)),''),
	coalesce(max(ie_exporta_cnes),'N'),
	coalesce(max(ie_exporta_cnes_hosp),'N'),
	coalesce(max(ie_exporta_cnes_setor),'N')
into STRICT	cd_cnes_w,
	ie_exporta_cnes_w,
	ie_exporta_cnes_hosp_w,
	ie_exporta_cnes_setor_w
from	sus_parametros_aih
where	cd_estabelecimento	= cd_estabelecimento_w;


if (cd_cbo_executor_w 	= '0') then
	cd_cbo_executor_w	:= null;
end if;
if (nr_cpf_executor_w	= '0') then
	nr_cpf_executor_w	:= null;
end if;

/* Para os procedimento do grupo 2 que possuem serviço/classificação não pode ser exportado o CPF e CBO,  exceto para  o procedimento 0211020010 - CATETERISMO CARDIACO*/

begin
select	coalesce(d.cd_grupo,0)
into STRICT	cd_grupo_w
from	sus_procedimento a,
	sus_forma_organizacao b,
	sus_subgrupo c,
	sus_grupo d
where	a.cd_procedimento	= cd_procedimento_w
and	a.ie_origem_proced	= ie_origem_proced_w
and	a.nr_seq_forma_org	= b.nr_sequencia
and	b.nr_seq_subgrupo	= c.nr_sequencia
and	c.nr_seq_grupo		= d.nr_sequencia  LIMIT 1;	
exception
	when others then
	cd_grupo_w		:= 0;
end;

select	count(1)
into STRICT	qt_registros_w
from	sus_proced_serv_classif
where	cd_procedimento		= cd_procedimento_w
and	ie_origem_proced	= ie_origem_proced_w  LIMIT 1;

if (cd_grupo_w	= 2) and (qt_registros_w > 0) and (cd_procedimento_w <> 0211020010) then
	nr_cpf_executor_w	:= null;
	cd_cbo_executor_w	:= null;
end if;

begin
select	substr(coalesce(cd_cnes,''),1,7)
into STRICT	cd_cnes_prestador_w
from	pessoa_juridica
where	cd_cgc	= cd_cgc_prestador_w  LIMIT 1;
exception
when others then
	cd_cnes_prestador_w := '';
end;

if (ie_exporta_cnes_setor_w = 'S') then
	begin

	begin
	select	substr(coalesce(max(cd_cnes),cd_cnes_prestador_w),1,7)
	into STRICT	cd_cnes_prestador_w
	from	setor_atendimento
	where	cd_setor_atendimento	= cd_setor_atendimento_w;
	exception
		when others then
		cd_cnes_prestador_w := cd_cnes_prestador_w;
		end;

	end;
end if;

if (cd_cgc_prestador_w	= cd_cgc_estab_w) and (cd_grupo_w		<> 7) then
	ie_doc_prestador_w	:= 5; /* CNES */
	cd_cgc_prestador_w	:= lpad(cd_cnes_w,14,' ');
else
	/* Sempre que o procedimento for OPM deve ser exportado o CNPJ */

	ie_doc_prestador_w	:= 3; /* CNPJ */
	if (cd_grupo_w		<> 7) and (cd_cnes_prestador_w IS NOT NULL AND cd_cnes_prestador_w::text <> '') then
		ie_doc_prestador_w	:= 5; /* CNES */
		cd_cgc_prestador_w	:= lpad(cd_cnes_prestador_w,14,' ');
	end if;
end if;

if (ie_doc_executor_w	= 1) then /* CPF */
	cd_doc_executor_w	:= nr_cpf_executor_w;
elsif (ie_doc_executor_w	= 3) then /* CNPJ */
	cd_doc_executor_w	:= cd_cgc_prestador_w;
elsif (ie_doc_executor_w	= 5) then /* CNES */
	cd_doc_executor_w	:= cd_cnes_w;
elsif (ie_doc_executor_w	= 6) then /* CNES Terc.*/
	if (cd_cnes_prestador_w IS NOT NULL AND cd_cnes_prestador_w::text <> '') then
		ie_doc_prestador_w	:= 5; /* CNES */
		cd_cgc_prestador_w	:= lpad(cd_cnes_prestador_w,14,' ');
	end if;
	ie_doc_executor_w	:= 5;
	cd_doc_executor_w	:= cd_cnes_prestador_w;
	
	if (ie_exporta_cnes_hosp_w	= 'S')	and (ie_exporta_cnes_setor_w 	= 'N')	then
		cd_cgc_prestador_w	:= cd_cnes_w;
	end if;
end if;

if (ie_exporta_cnes_w = 'S') then
	begin
	select	coalesce(ie_tipo_servico_sus,0)
	into STRICT	ie_tipo_servico_w
	from	medico_convenio
	where	cd_pessoa_fisica	= cd_codigo_executor_w
	and	cd_convenio	= cd_convenio_w;
	exception
	when others then
		ie_tipo_servico_w	:= 30;
	end;
else
	/* Esse select deverá ser trocado por um select de um novo cadastro que temos que fazer na SUS AIH2008 */

	select	coalesce(max(ie_tipo_servico_sus),0)
	into STRICT	ie_tipo_servico_w
	from	medico_convenio
	where	cd_pessoa_fisica	= cd_codigo_executor_w
	and	cd_convenio	= cd_convenio_w;
end if;


select	coalesce(max(ie_credenciamento),ie_tipo_servico_w)
into STRICT	ie_credenciamento_w
from	sus_medico_credenciamento
where	cd_medico  = cd_codigo_executor_w
and	coalesce(cd_cbo,coalesce(cd_cbo_executor_w,'X')) = coalesce(cd_cbo_executor_w,'X')
and	coalesce(ie_situacao,'A') = 'A'
and	coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w;

if (sus_validar_regra(12, cd_procedimento_w, ie_origem_proced_w,dt_procedimento_w) > 0) and (ie_doc_prestador_w = 5) and (ie_credenciamento_w	<> '30') and (cd_procedimento_w not in (0802020011, 0309010047)) then
	cd_cgc_prestador_ww	:= null;
end if;


/* Obter a regra de alteração no disquete para excluir ou não o Médico ou CNES */

SELECT * FROM sus_obter_regra_expaih(nr_sequencia_w, 'Tasy', nr_seq_regra_w, ie_exclui_medico_w, ie_exclui_cnes_w, ie_exclui_procedimento_w, nr_seq_participante_p) INTO STRICT nr_seq_regra_w, ie_exclui_medico_w, ie_exclui_cnes_w, ie_exclui_procedimento_w;

if (ie_exclui_medico_w = 'S') then
	nr_cns_executor_w	:= null;
	nr_cpf_executor_w	:= null;
	cd_cbo_executor_w	:= null;
end if;

if (ie_exclui_cnes_w = 'S') then
	cd_cgc_prestador_w	:= null;
end if;

if (ie_opcao_p	= 'CPF') then
	if (trunc(dt_procedimento_w,'month') < to_date('01/01/2012','dd/mm/yyyy')) then
		ds_retorno_w	:= nr_cpf_executor_w;
	elsif (trunc(dt_procedimento_w,'month') >= to_date('01/01/2012','dd/mm/yyyy')) then
		ds_retorno_w	:= nr_cns_executor_w;
	end if;
elsif (ie_opcao_p	= 'CBO') then
	ds_retorno_w	:= cd_cbo_executor_w;
elsif (ie_opcao_p	= 'CNPJ') then
	ds_retorno_w	:= cd_cgc_prestador_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_espelho_aih (nr_sequencia_p bigint, nr_seq_participante_p bigint, ie_opcao_p text) FROM PUBLIC;

