-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_autoriz_proced ( nr_prescricao_p bigint, nr_atendimento_p bigint) AS $body$
DECLARE


cd_convenio_w			integer;
cd_plano_convenio_w		varchar(10);
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
nr_sequencia_w			integer;
cd_setor_atendimento_w		integer;
ds_retorno_w			varchar(2000);
ie_bloqueia_w			varchar(10);
ie_regra_w			varchar(3);
dt_prescricao_w			timestamp;
qt_procedimento_w			integer;
ds_erro_w			varchar(255);
nr_seq_regra_retorno_w		bigint;
nr_seq_proc_interno_w		bigint;
cd_categoria_w			varchar(10);
cd_estabelecimento_w		smallint;
cd_medico_atend_w		varchar(10);
nr_seq_agenda_w			prescr_procedimento.nr_seq_agenda%type;
nr_seq_agenda_int_w		bigint;
cd_medico_exec_w			varchar(10);
cd_pessoa_fisica_w		varchar(10);
ie_glosa_w			regra_ajuste_proc.ie_glosa%type;
nr_seq_regra_preco_w		regra_ajuste_proc.nr_sequencia%type;
ie_atualiza_med_autor_w	varchar(10);
nr_seq_exame_w prescr_procedimento.nr_seq_exame%type;

c01 CURSOR FOR
SELECT	b.cd_procedimento,
	b.ie_origem_proced,
	b.nr_sequencia,
	b.nr_seq_exame,
	CASE WHEN coalesce(b.cd_setor_atendimento::text, '') = '' THEN a.cd_setor_atendimento  ELSE b.cd_setor_atendimento END ,
	a.dt_prescricao,
	b.qt_procedimento,
	b.nr_seq_proc_interno,
	b.nr_seq_agenda,
	b.cd_medico_exec
from	prescr_procedimento b,
	prescr_medica a
where	b.nr_prescricao	= nr_prescricao_p
and	a.nr_prescricao = b.nr_prescricao;



BEGIN

ie_atualiza_med_autor_w := obter_param_usuario(869, 442, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ie_atualiza_med_autor_w);

select	obter_convenio_atendimento(nr_atendimento_p)
into STRICT	cd_convenio_w
;

select	coalesce(max(cd_plano_convenio),'0'),
	max(cd_categoria),
	max(b.cd_estabelecimento),
	max(b.cd_pessoa_fisica)
into STRICT	cd_plano_convenio_w,
	cd_categoria_w,
	cd_estabelecimento_w,
	cd_pessoa_fisica_w
from 	atendimento_paciente b,
	atend_categoria_convenio a
where	a.nr_atendimento 		= nr_atendimento_p
  and	a.nr_atendimento		= b.nr_atendimento
  and	a.cd_convenio		= cd_convenio_w
  and 	dt_inicio_vigencia		=
	(SELECT max(dt_inicio_vigencia)
	from atend_categoria_convenio b
	where nr_atendimento 	= nr_atendimento_p);

select	max(cd_medico_resp)
into STRICT	cd_medico_atend_w
from	atendimento_paciente
where	nr_atendimento	= nr_atendimento_p;

open c01;
loop
fetch c01 into
	cd_procedimento_w,
	ie_origem_proced_w,
	nr_sequencia_w,
	nr_seq_exame_w,
	cd_setor_atendimento_w,
	dt_prescricao_w,
	qt_procedimento_w,
	nr_seq_proc_interno_w,
	nr_seq_agenda_w,
	cd_medico_exec_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	--Rafael em 13/04/2006 OS32186. incluido o parametro nr_seq_exame(0);

--	consiste_proc_plano_convenio(cd_convenio_w,cd_plano_convenio_w,cd_procedimento_w,ie_origem_proced_w, Edgar 10/10/2006 OS 30405,

--				     nr_atendimento_p,cd_setor_atendimento_w,0,ds_retorno_w,ie_bloqueia_w); troquei consiste_proc_plano_convenio

--															por consiste_plano_convenio
	SELECT * FROM consiste_plano_convenio(nr_atendimento_p, cd_convenio_w, cd_procedimento_w, ie_origem_proced_w, dt_prescricao_w, qt_procedimento_w, null, cd_plano_convenio_w, null, ds_erro_w, cd_setor_atendimento_w, coalesce(nr_seq_exame_w,0), ie_regra_w, null, nr_seq_regra_retorno_w, nr_seq_proc_interno_w, cd_categoria_w, cd_estabelecimento_w, null, cd_medico_exec_w, cd_pessoa_fisica_w, ie_glosa_w, nr_seq_regra_preco_w) INTO STRICT ds_erro_w, ie_regra_w, nr_seq_regra_retorno_w, ie_glosa_w, nr_seq_regra_preco_w;

--	if	(ie_bloqueia_w = 'S') then			Edgar 10/10/2006 OS 30405
	if (ie_regra_w in (1,2)) then
		update	prescr_procedimento
		set	ie_autorizacao 	= 'B'
		where	nr_sequencia	= nr_sequencia_w
		and	nr_prescricao	= nr_prescricao_p;
--	elsif	(ds_retorno_w is not null) or			Edgar 10/10/2006 OS 30405

--		(ds_retorno_w <> '') then

	/* Francisco - OS 95854 - 10/06/2008 - Inclui a regra 6 para marcar como pendente tambem */


	/* Francisco - OS 99385 - 22/07/2008 - Inclui a regra 7 para marcar como pendente tambem */


	/* Geliard   - OS356602 - 04/10/2011 - Inclui o not exists para nao alterar quando ja estiver autorizada, cancelada ou reprovada*/

	elsif (ie_regra_w in (3,6,7)) then
		update	prescr_procedimento a
		set	a.ie_autorizacao 	= 'PA'
		where	a.nr_sequencia	= nr_sequencia_w
		and	a.nr_prescricao	= nr_prescricao_p
		and	not exists (	SELECT	1
					from	autorizacao_convenio x,
						procedimento_autorizado y,
						estagio_autorizacao z
					where	x.nr_sequencia 	 		= y.nr_sequencia_autor
					and	x.nr_seq_estagio 		= z.nr_sequencia
					and	coalesce(x.nr_prescricao,nr_prescricao_p) = nr_prescricao_p
					and	x.nr_atendimento		= nr_atendimento_p
					and	y.cd_procedimento		= a.cd_procedimento
					and	y.ie_origem_proced		= a.ie_origem_proced
					and	z.ie_interno in (10,70,90));
	end if;

	if (ie_atualiza_med_autor_w = 'S') then
		if (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') then
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_agenda_int_w
			from	agenda_integrada a,
				agenda_integrada_item b,
				agenda_paciente c
			where	a.nr_sequencia		= b.nr_seq_agenda_int
			and	b.nr_seq_agenda_exame	= c.nr_sequencia
			and	c.nr_sequencia		= nr_seq_agenda_w;
		
			if (nr_seq_agenda_int_w IS NOT NULL AND nr_seq_agenda_int_w::text <> '') and (cd_medico_atend_w IS NOT NULL AND cd_medico_atend_w::text <> '') then
				update	autorizacao_convenio
				set	cd_medico_solicitante	= cd_medico_atend_w
				where	nr_seq_age_integ	= nr_seq_agenda_int_w;
			end if;
		end if;
	end if;
end loop;
close c01;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_autoriz_proced ( nr_prescricao_p bigint, nr_atendimento_p bigint) FROM PUBLIC;
