-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_grupos_aud_conta ( nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_conta_w			varchar(4000);
ie_tipo_conta_w			varchar(10);
ie_pre_analise_w		varchar(2);
ie_tipo_item_w			varchar(1);
ie_origem_conta_w		varchar(1);
ie_intercambio_w		varchar(1) := 'N';
ie_conta_medica_w		varchar(1) := 'N';
ie_fluxo_nao_utilizado_w	varchar(1) := 'N';
nr_seq_grupo_w			bigint;
nr_seq_fluxo_w			bigint;	
ie_existe_grupo_analise_w	bigint;
nr_seq_grupo_auditor_w		bigint;
nr_ie_tipo_item_w		bigint;
nr_seq_ocorrencia_w		bigint;
nr_seq_min_ordem_w		bigint;
nr_seq_fluxo_ww			bigint;
nr_seq_conta_w			bigint;
ie_origem_analise_w		pls_analise_conta.ie_origem_analise%type;
C01 CURSOR FOR
	SELECT	nr_seq_grupo,
		nr_seq_fluxo,
		nr_seq_ocorrencia
	from	pls_ocorrencia_grupo	a
	where	nr_seq_ocorrencia in	(SELECT	nr_seq_ocorrencia
					from	pls_ocorrencia_benef
					where	coalesce(nr_seq_guia_plano::text, '') = ''
					and	coalesce(nr_seq_requisicao::text, '') = ''
					and	((nr_seq_mat 	= nr_seq_conta_mat_p) or (nr_seq_proc 	= nr_seq_conta_proc_p)))
	and	coalesce(ie_conta_medica,'N')	= 'S'
	and	a.ie_situacao	= 'A'
	and	((ie_intercambio = 'S') or (ie_intercambio = ie_intercambio_w))
	and	coalesce(ie_origem_conta, coalesce(ie_origem_conta_w,'0'))	= coalesce(ie_origem_conta_w,'0')
	and	((coalesce(a.ie_tipo_analise::text, '') = '') or (a.ie_tipo_analise = 'A') or (a.ie_tipo_analise = 'C' and ie_origem_analise_w in ('1','3','4','5','6')) or (a.ie_tipo_analise	= 'P' and ie_origem_analise_w in ('2','7')));/*Diego OS 310737*/
 /*Robson - para contas de intercambio, fatura 2320*/
	

BEGIN
select	nr_seq_conta
into STRICT	nr_seq_conta_w
from	pls_conta_proc
where	nr_sequencia	= nr_seq_conta_proc_p

union

SELECT	nr_seq_conta
from	pls_conta_mat
where	nr_sequencia	= nr_seq_conta_mat_p;

begin
select	ie_origem_conta,
	ie_tipo_conta
into STRICT	ie_origem_conta_w,
	ie_tipo_conta_w
from	pls_conta
where	nr_sequencia	= nr_seq_conta_w;
exception
when others then
	ie_origem_conta_w	:= null;
	ie_tipo_conta_w		:= 'O';
end;

if (ie_tipo_conta_w = 'I') then
	ie_conta_medica_w	:= null;
else
	ie_conta_medica_w	:= 'S';
end if;

select	CASE WHEN a.ie_origem_analise=3 THEN 'I'  ELSE 'N' END ,
	ie_origem_analise
into STRICT	ie_intercambio_w,
	ie_origem_analise_w
from	pls_analise_conta	a
where	a.nr_sequencia	= nr_seq_analise_p;

/*Obter o grupo de analise atual*/

select	min(nr_seq_ordem)
into STRICT	nr_seq_min_ordem_w
from	pls_auditoria_conta_grupo
where	nr_seq_analise	= nr_seq_analise_p
and	coalesce(dt_liberacao::text, '') = ''
and	(nm_auditor_atual IS NOT NULL AND nm_auditor_atual::text <> '');

/*Obtem os grupos das ocorrencias das contas*/

open C01;
loop
fetch C01 into	
	nr_seq_grupo_w,
	nr_seq_fluxo_w,
	nr_seq_ocorrencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_fluxo_nao_utilizado_w := 'N';
	
	select	max(ie_pre_analise)
	into STRICT	ie_pre_analise_w
	from	pls_ocorrencia
	where	nr_sequencia = nr_seq_ocorrencia_w;
	
	if (ie_intercambio_w IS NOT NULL AND ie_intercambio_w::text <> '') or
		((coalesce(ie_pre_analise_w,'N') = 'N') and (ie_conta_medica_w IS NOT NULL AND ie_conta_medica_w::text <> '')) then
		begin
		if (nr_seq_fluxo_w <= nr_seq_min_ordem_w) then
			nr_seq_fluxo_w	:= nr_seq_min_ordem_w;
		
			while(ie_fluxo_nao_utilizado_w = 'N') loop
				begin
				nr_seq_fluxo_w	:= nr_seq_fluxo_w + 1;
				
				select	CASE WHEN count(nr_sequencia)=0 THEN  'S'  ELSE 'N' END
				into STRICT	ie_fluxo_nao_utilizado_w
				from	pls_auditoria_conta_grupo
				where	nr_seq_analise	= nr_seq_analise_p
				and	nr_seq_ordem	= nr_seq_fluxo_w;
				end;
			end loop;
		end if;
		
		/*Verifica se existe o grupo na analise*/

		select	count(a.nr_sequencia)
		into STRICT	ie_existe_grupo_analise_w
		from	pls_auditoria_conta_grupo a,
			pls_analise_conta	  b
		where	b.nr_sequencia		= a.nr_seq_analise	
		and	a.nr_seq_grupo		= nr_seq_grupo_w
		and	a.nr_seq_analise	= nr_seq_analise_p;		
			
		if (ie_existe_grupo_analise_w > 0) then
			/*Se existir o grupo concatena o numero da conta no DS_CONTA*/

			ds_conta_w	:= ds_conta_w ||','|| to_char(nr_seq_conta_w);
			
			update	pls_auditoria_conta_grupo
			set	ds_conta	= ds_conta_w,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_seq_grupo	= nr_seq_grupo_w;
		else	
			select	nextval('pls_auditoria_conta_grupo_seq')
			into STRICT	nr_seq_grupo_auditor_w
			;
			
			/*Se nao existir cria-se o grupo*/
		
			insert into pls_auditoria_conta_grupo(nr_sequencia,
				nr_seq_analise,
				nr_seq_grupo,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_ordem,
				ds_conta)
			values (nr_seq_grupo_auditor_w,
				nr_seq_analise_p,
				nr_seq_grupo_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_fluxo_w,
				to_char(nr_seq_conta_w));	
				
			update	pls_analise_conta
			set	ie_auditoria	= 'S'
			where	nr_Sequencia	= nr_seq_analise_p;
		end if;
		end;
	end if;
	
	end;
end loop;
close C01;

CALL pls_atualizar_grupo_penden(nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_grupos_aud_conta ( nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
