-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_glosas_oco_usuario ( nr_seq_analise_p bigint, nr_seq_mot_liberacao_p bigint, ds_observacao_p text, cd_estabelecimento_p bigint, nr_seq_grupo_atual_p bigint, ds_contas_p text, ds_procs_p text, ds_mats_p text, nm_usuario_p text ) AS $body$
DECLARE


/*Procedure que verifica as glosas e ocorrencias da analise e liberar todas as possiveis para aquele usuario
    No caso da ocorrencia e verificado se o usuario possui liberacao e se faz parte do grupo do analistas da ocorrnecia
    No caso de glosa como ainda nao ha grupos por glosas e liberado so as glosas ligadas a ocorrencia (realizado dentro da procedure pls_conta_liberar_glosa_oc)
    No caso de haver uma valor informado no DS_ITENS_P o sistema libera somente daqueles itens*/
nr_sequencia_w				bigint;
nr_seq_conta_proc_w			bigint;
nr_seq_conta_mat_w			bigint;
nr_seq_conta_w				bigint;
nr_seq_glosa_oc_w				bigint;
ie_tipo_w    				varchar(1);
nr_nivel_liberacao_auditor_w			bigint;
nr_nivel_liberacao_w			bigint;
nr_seq_oc_benef_w			bigint;
cd_ocorrencia_w				varchar(15);
ds_mensagem_w				varchar(4000);
ie_ocorrencia_w				pls_controle_estab.ie_ocorrencia%type := pls_obter_se_controle_estab('GO');
cd_estabelecimento_w			estabelecimento.cd_estabelecimento%type;

C01 CURSOR FOR
	SELECT	x.nr_sequencia,
		x.nr_seq_conta_proc,
		x.nr_seq_conta_mat,
		x.nr_seq_conta,
		x.nr_seq_glosa_oc,
		x.ie_tipo
	from	pls_analise_conta_item x
	where	x.nr_seq_analise = nr_seq_analise_p
	and (x.ie_tipo = 'O')		
	and	(((coalesce(ds_mats_p,'X') = 'X') and (coalesce(ds_procs_p,'X') = 'X')) or ((position(x.nr_seq_conta_mat in ds_mats_p) > 0) or (position(x.nr_seq_conta_proc in ds_procs_p) > 0) or ((position(nr_seq_conta in ds_contas_p) > 0) and ((coalesce(x.nr_seq_conta_mat,0) = 0) and (coalesce(x.nr_seq_conta_proc,0) = 0))))) /*Ou e pra liberar o item ou a*/
	and	((exists (	SELECT	a.nr_sequencia
				from	pls_membro_grupo_aud a,
					pls_ocorrencia_grupo b
				where	a.nr_seq_grupo			= b.nr_seq_grupo
				and	coalesce(a.nm_usuario_exec,'X') 	= nm_usuario_p
				and	a.nr_seq_grupo		 	= nr_seq_grupo_atual_p
				and	b.ie_situacao			= 'A'
				and 	b.nr_seq_ocorrencia 		in (	select	max(y.nr_sequencia)
										from	pls_ocorrencia y
										where	y.cd_ocorrencia = x.cd_codigo
										and	ie_ocorrencia_w = 'S'
										and	y.cd_estabelecimento = cd_estabelecimento_w
										
union all

										select	max(y.nr_sequencia)
										from	pls_ocorrencia y
										where	y.cd_ocorrencia = x.cd_codigo
										and	ie_ocorrencia_w = 'N')
				and	a.ie_situacao = 'A'	)) or
		( not exists (select	a.nr_sequencia
				from	pls_membro_grupo_aud a,
					pls_ocorrencia_grupo b
				where	a.nr_seq_grupo			= b.nr_seq_grupo
				--and	nvl(a.nm_usuario_exec,'X') 	= nm_usuario_p

				--and	a.nr_seq_grupo		 	= nr_seq_grupo_atual_p 
				and	b.ie_situacao 			= 'A'
				and 	b.nr_seq_ocorrencia 		= (	select	max(y.nr_sequencia)
										from	pls_ocorrencia y
										where	y.cd_ocorrencia = x.cd_codigo))))
	and	x.ie_status = 'P'
	order by 1;	


BEGIN

cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	nr_seq_conta_proc_w,
	nr_seq_conta_mat_w,
	nr_seq_conta_w,
	nr_seq_glosa_oc_w,
	ie_tipo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin	
	
	begin
	select	c.nr_nivel_liberacao,
		a.nr_sequencia,
		a.cd_ocorrencia
	into STRICT	nr_nivel_liberacao_w,
		nr_seq_oc_benef_w,
		cd_ocorrencia_w
	FROM pls_ocorrencia_benef b, pls_ocorrencia a
LEFT OUTER JOIN pls_nivel_liberacao c ON (a.nr_seq_nivel_lib = c.nr_sequencia)
WHERE b.nr_seq_ocorrencia = a.nr_sequencia  and b.nr_sequencia = nr_seq_glosa_oc_w;
	exception
	when others then
		nr_nivel_liberacao_w := null;
		nr_seq_oc_benef_w	 := null;
		cd_ocorrencia_w		 := null;
	end;
	
	nr_nivel_liberacao_auditor_w := (coalesce(pls_obter_dados_auditor(cd_ocorrencia_w, null, nm_usuario_p, 'L', nr_seq_grupo_atual_p),0))::numeric;
	
	/*Realizado a verificacao antes de chamar a procedure, mesmo ela tendo esta verificacao dentro pois, a procedure possui um raisi (pra nao dizer com e por que nao pode documentar assim) ao  realizar esta verificacao*/

	
	if (coalesce(nr_nivel_liberacao_auditor_w,0) >= coalesce(nr_nivel_liberacao_w, coalesce(nr_nivel_liberacao_auditor_w,0))) then
		begin
		
		CALL pls_conta_liberar_glosa_oc(nr_sequencia_w, nr_seq_analise_p, nr_seq_mot_liberacao_p,
					   ds_observacao_p, nm_usuario_p, cd_estabelecimento_p, 		   
					   nr_seq_grupo_atual_p, 'S', 'N','N');
		exception
		when others then
			nr_nivel_liberacao_auditor_w := nr_nivel_liberacao_auditor_w;
		end;
	else
		if (coalesce(ds_mensagem_w,'X') = 'X') then
			ds_mensagem_w := cd_ocorrencia_w;
		else
			ds_mensagem_w := coalesce(ds_mensagem_w,'')||', '||cd_ocorrencia_w;
		end if;
	end if;

	end;
end loop;
close C01;

if (coalesce(ds_mensagem_w,'X') <> 'X') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(179889, 'DS_MENSAGEM_W='||ds_mensagem_w);
					/*'As seguintes ocorrencias nao puderem ser liberadas:'||chr(10)||chr(13)||
					chr(9)||ds_mensagem_w||chr(10)||chr(13)||
					'Verifique as respectivas permissoes.';*/
					
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_glosas_oco_usuario ( nr_seq_analise_p bigint, nr_seq_mot_liberacao_p bigint, ds_observacao_p text, cd_estabelecimento_p bigint, nr_seq_grupo_atual_p bigint, ds_contas_p text, ds_procs_p text, ds_mats_p text, nm_usuario_p text ) FROM PUBLIC;
