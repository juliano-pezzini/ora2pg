-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consitir_grau_espec ( nr_seq_grau_partic_p bigint, cd_medico_p bigint, nr_seq_conta_p bigint, nr_seq_proc_p bigint, cd_estabelecimento_p bigint, nr_seq_segurado_p bigint, nm_usuario_p text, ie_gerou_ocorrencia_p INOUT text, nr_seq_ocorrencia_p bigint, ie_reconsistencia_p text, ie_tipo_ocorrencia_p text, nr_Seq_participante_p bigint) AS $body$
DECLARE


qt_regra_partic_w		bigint;
qt_regra_espec_w		bigint;
nr_seq_ocorrencia_w		bigint;
ie_gerou_ocorrencia_w		varchar(1) := 'N';
qt_ocorrencia_w			bigint;
cd_ocorrencia_w			varchar(10);
cd_motivo_glosa_w		varchar(10);
nr_seq_ocorrencia_benef_w	bigint;
nr_seq_oc_benef_w		bigint;
ie_alterado_analise_w		varchar(2) := 'N';
nr_seq_regra_w			bigint;
qt_espec_exec_w			bigint;
ie_tipo_guia_w			varchar(2);
ie_tipo_item_w			varchar(2);
qt_existe_restricao_w		bigint;
qt_insere_w			bigint;
qt_participante_w		bigint;
qt_regra_partic_igual_w		bigint;
/*25/10/2011
   Alterado para seguir a lógia da Ocorrência e assim  ser utilizada na rotina decorreção de ocorrência na análise.
   Em vez de verificar em todo as regras de rtodas as ocorrências as as que possuem regra informado será realizado dentro de uma ocorrência.*/
C01 CURSOR FOR

	SELECT  a.nr_sequencia,
		b.nr_sequencia
	from	pls_oc_grau_partic_espec 	a,
		pls_ocorrencia 			b
	where	a.nr_seq_ocorrencia	= b.nr_sequencia
	and	a.nr_seq_grau_partic	= nr_seq_grau_partic_p
	and	b.ie_situacao 		= 'A'
	and	coalesce(nr_seq_ocorrencia_p, b.nr_sequencia) = b.nr_sequencia;



BEGIN

begin
	select	ie_tipo_guia
	into STRICT	ie_tipo_guia_w
	from 	pls_conta
	where	nr_sequencia = nr_seq_conta_p;
exception
when others then
	ie_tipo_guia_w := null;
end;

open C01;
loop
fetch C01 into
	nr_seq_regra_w,
	nr_seq_ocorrencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	/* Verifica a quantidade de participantes,  para restringir se  houver participante*/

	select	count(1)
	into STRICT	qt_participante_w
	from	pls_proc_participante a,
		pls_conta_proc	b,
		pls_conta	c
	where	a.nr_seq_conta_proc	= nr_seq_proc_p
	and	a.nr_seq_conta_proc	= b.nr_sequencia
	and	c.nr_sequencia		= b.nr_seq_conta
	and	coalesce(a.ie_status,'U') 	<> 'C';
	/*Verificar se já existe esta ocorrencia gerada*/

	/*	ASKONO - REMOVI AS VERIFICAÇÕES SE OCORRÊNCIA EXISTE
		if	(nvl(nr_seq_proc_p,0) > 0) then
			select	count(1)
			into	qt_ocorrencia_w
			from	pls_ocorrencia_benef
			where	nr_seq_ocorrencia		= nr_seq_ocorrencia_p
			and	nr_seq_conta			= nr_seq_conta_p
			and	nr_seq_proc			= nr_seq_proc_p;
		else
			select	count(1)
			into	qt_ocorrencia_w
			from	pls_ocorrencia_benef
			where	nr_seq_ocorrencia		= nr_seq_ocorrencia_p
			and	nr_seq_conta			= nr_seq_conta_p;
			--and	nvl(nr_seq_proc,0)	 	= 0
			--and	nvl(nr_seq_mat,0) 		= 0;
		end if;

		if	(qt_ocorrencia_w > 0) and
			(nvl(ie_reconsistencia_p,'N') = 'N') then
			goto final;
		end if;
	*/
	select 	count(1)
	into STRICT 	qt_espec_exec_w
	from 	medico_especialidade
	where 	cd_pessoa_fisica = cd_medico_p;

	if (qt_espec_exec_w > 0)	then
		/*Verificar se existe regra de especifica da particiação e e especialidade.*/

		/* neste select a rotina conta a quantidade de regras cadastrada  e se a especialidade do médico não estiver cadastrada ai gera a glosa */

		select	count(a.nr_sequencia)
		into STRICT	qt_regra_espec_w
		from	pls_oc_grau_partic_espec  a
		where	a.nr_seq_grau_partic    = nr_seq_grau_partic_p
		and	nr_seq_ocorrencia 	= nr_seq_ocorrencia_w
		and	a.nr_sequencia in ( SELECT  b.nr_seq_regra
					    from    pls_regra_partic_espec b
					    where   cd_especialidade in ( select c.cd_especialidade -- somente as especialidades que não estam cadastradas na regra
									  from	medico_especialidade c
									  where	c.cd_pessoa_fisica = cd_medico_p));

		/*Se não existir a regra especifica gera-se ocorrencia*/

		if (qt_regra_espec_w = 0) then
			if (coalesce(ie_reconsistencia_p,'N') = 'N') /*or	(qt_ocorrencia_w = 0)*/
  then

				if (coalesce(nr_seq_proc_p,0) > 0) then
					ie_tipo_item_w	:= 3;
				else
					ie_tipo_item_w	:= 8;
				end if;

				select  count(1)
				into STRICT	qt_existe_restricao_w
				from 	pls_oc_partic_espec_aplic c
				where	c.nr_seq_regra_espec = nr_seq_regra_w;

				if (qt_existe_restricao_w > 0) then

					select 	count(1)
					into STRICT	qt_insere_w
					from 	pls_oc_partic_espec_aplic
					where	nr_seq_regra_espec = nr_seq_regra_w
					and	((ie_tipo_guia = ie_tipo_guia_w) or (coalesce(ie_tipo_guia,0)=0))
					and (ie_tipo_ocorrencia = ie_tipo_ocorrencia_p);

				end if;


				if	(qt_existe_restricao_w > 0 AND qt_insere_w > 0) or (qt_existe_restricao_w = 0) then

					nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_w, null, null, nr_seq_conta_p, nr_seq_proc_p, null, nr_seq_regra_w, nm_usuario_p, '', '', ie_tipo_item_w, cd_estabelecimento_p, 'S', null, nr_seq_oc_benef_w, null, nr_Seq_participante_p, null, null);
					ie_gerou_ocorrencia_w := 'S';

					if (coalesce(nr_Seq_participante_p,0) = 0) then
						goto final2;
					end if;
				end if;
			else
					if (coalesce(nr_seq_proc_p,0) > 0) then
					update	pls_ocorrencia_benef
					set	ie_situacao			= 'A'
					where	nr_seq_ocorrencia		= nr_seq_ocorrencia_w
					and	nr_seq_conta			= nr_seq_conta_p
					and	nr_seq_proc			= nr_seq_proc_p;
				else
					update	pls_ocorrencia_benef
					set	ie_situacao			= 'A'
					where	nr_seq_ocorrencia		= nr_seq_ocorrencia_w
					and	nr_seq_conta			= nr_seq_conta_p
					and	nr_seq_proc			= 0
					and	nr_seq_mat		 	= 0;
				end if;
			end if;

			ie_gerou_ocorrencia_w := 'S';
		end if;
	end if;
	<<final>>
	null;
	end;
end loop;
close C01;

<<final2>>
if (C01%ISOPEN) then
	close C01;
end if;

ie_gerou_ocorrencia_p := ie_gerou_ocorrencia_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consitir_grau_espec ( nr_seq_grau_partic_p bigint, cd_medico_p bigint, nr_seq_conta_p bigint, nr_seq_proc_p bigint, cd_estabelecimento_p bigint, nr_seq_segurado_p bigint, nm_usuario_p text, ie_gerou_ocorrencia_p INOUT text, nr_seq_ocorrencia_p bigint, ie_reconsistencia_p text, ie_tipo_ocorrencia_p text, nr_Seq_participante_p bigint) FROM PUBLIC;
