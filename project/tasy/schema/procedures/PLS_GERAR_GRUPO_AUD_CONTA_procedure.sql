-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_grupo_aud_conta ( nr_seq_conta_p bigint, nr_seq_analise_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ds_conta_w			varchar(4000);
ie_tipo_conta_w			varchar(10);
ie_intercambio_w		varchar(10) := 'N';
ie_conta_medica_w		varchar(10) := 'N';
ie_pre_analise_w		varchar(2);
ie_tipo_item_w			varchar(1);
ie_origem_conta_w		varchar(1);
ie_tipo_despesa_w		varchar(1);
ie_despesa_w			varchar(1)	:= 'N';
nr_seq_grupo_w			bigint;
nr_seq_fluxo_w			bigint;		
ie_existe_grupo_analise_w	bigint;
nr_seq_grupo_auditor_w		bigint;
nr_ie_tipo_item_w		bigint;
nr_seq_ocorrencia_w		bigint;
nr_seq_grupo_ww			bigint;
qt_ocorr_conta_w		bigint;
qt_ocorr_w			bigint;
nr_seq_ocorr_grupo_w		bigint;
qt_oco_despesa_w		bigint;
ie_origem_analise_w		pls_analise_conta.ie_origem_analise%type;

C01 CURSOR FOR
	SELECT	a.nr_seq_grupo,
		a.nr_seq_fluxo,
		a.nr_seq_ocorrencia,
		a.nr_sequencia
	from	pls_ocorrencia_grupo	a,
		pls_grupo_auditor	b
	where	b.nr_sequencia  = a.nr_seq_grupo
	and	a.nr_seq_ocorrencia in	(SELECT	x.nr_seq_ocorrencia
					from	pls_ocorrencia_benef	x,
						pls_ocorrencia		y
					where	x.nr_seq_conta	= nr_seq_conta_p
					and	y.nr_sequencia	= x.nr_seq_ocorrencia
					and	((x.ie_situacao 	= 'A') or (coalesce(y.ie_auditoria_conta,'N')	= 'N')))
	and	coalesce(a.ie_conta_medica,'N')	= 'S'
	and	a.ie_situacao = 'A'
	and	((a.ie_intercambio = 'S') or (a.ie_intercambio = ie_intercambio_w))
	and 	b.ie_situacao = 'A'
	and	coalesce(a.ie_origem_conta,coalesce(ie_origem_conta_w,'0'))	= coalesce(ie_origem_conta_w,'0')
	and	((coalesce(a.ie_tipo_analise::text, '') = '') or (a.ie_tipo_analise = 'A') or (a.ie_tipo_analise = 'C' and ie_origem_analise_w in ('1','3','4','5','6')) or (a.ie_tipo_analise	= 'P' and ie_origem_analise_w in ('2','7')));/*Diego OS 310737*/
 /*Robson - para contas de intercambio, fatura 2320*/
		

BEGIN
begin
select	ie_origem_conta,
	ie_tipo_conta
into STRICT	ie_origem_conta_w,
	ie_tipo_conta_w
from	pls_conta
where	nr_sequencia	= nr_seq_conta_p;
exception
when others then
	ie_origem_conta_w	:= null;
	ie_tipo_conta_w		:= 'O';
end;

if (ie_tipo_conta_w = 'I') then
	ie_conta_medica_w	:= 'N';
else
	ie_conta_medica_w	:= 'S';
end if;

select	CASE WHEN a.ie_origem_analise=3 THEN 'I'  ELSE 'N' END ,
	ie_origem_analise
into STRICT	ie_intercambio_w,
	ie_origem_analise_w
from	pls_analise_conta	a
where	a.nr_sequencia	= nr_seq_analise_p;

select	count(1)
into STRICT	qt_ocorr_conta_w
from	pls_ocorrencia_benef	x
where	x.nr_seq_conta		= nr_seq_conta_p
and	coalesce(x.nr_seq_proc::text, '') = ''
and	coalesce(x.nr_seq_mat::text, '') = '';

select	count(1)
into STRICT	qt_ocorr_w
from	pls_ocorrencia_benef	x
where	x.nr_seq_conta		= nr_seq_conta_p;

if (qt_ocorr_conta_w = qt_ocorr_w) then
	ie_despesa_w	:= 'S';
end if;

/*Obtem os grupos das ocorrencias das contas */

open C01;
loop
fetch C01 into	
	nr_seq_grupo_w,
	nr_seq_fluxo_w,
	nr_seq_ocorrencia_w,
	nr_seq_ocorr_grupo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_despesa_w	:= 'N';
	
	select	count(1)
	into STRICT	qt_oco_despesa_w
	from	pls_oc_grupo_tipo_desp
	where	nr_seq_ocorrencia_grupo = nr_seq_ocorr_grupo_w  LIMIT 1;
	
	if (qt_oco_despesa_w = 0) then
		ie_despesa_w	:= 'S';
	end if;
	
	if (ie_despesa_w = 'N') then
		select	max(pls_obter_se_grupo_tipo_desp(nr_seq_ocorr_grupo_w,y.ie_tipo_despesa,'P'))
		into STRICT	ie_despesa_w
		from	pls_conta_proc		y,
			pls_ocorrencia_benef	x
		where	x.nr_seq_conta		= nr_seq_conta_p
		and	y.nr_sequencia		= x.nr_seq_proc
		and	x.nr_seq_ocorrencia	= nr_seq_ocorrencia_w;
		
		if (coalesce(ie_despesa_w,'N') = 'N') then
			select	max(pls_obter_se_grupo_tipo_desp(nr_seq_ocorr_grupo_w,y.ie_tipo_despesa,'M'))
			into STRICT	ie_despesa_w
			from	pls_conta_mat		y,
				pls_ocorrencia_benef	x
			where	x.nr_seq_conta		= nr_seq_conta_p
			and	y.nr_sequencia		= x.nr_seq_mat
			and	x.nr_seq_ocorrencia	= nr_seq_ocorrencia_w;
			
			if (coalesce(ie_despesa_w::text, '') = '') then
				ie_despesa_w	:= 'N';
			end if;
		end if;
	end if;
	
	if (coalesce(ie_despesa_w,'S') = 'S') then
		select	max(ie_pre_analise)
		into STRICT	ie_pre_analise_w
		from	pls_ocorrencia
		where	nr_sequencia 	= nr_seq_ocorrencia_w  LIMIT 1;
		/*Criado o tratamento para que caso nao for conta de intercambio nao gere grupo de pre analise OS416035 Diogo*/

		if (coalesce(ie_intercambio_w,'X') <> 'X') or
			((coalesce(ie_pre_analise_w,'N') = 'N') and (coalesce(ie_conta_medica_w,'X') <> 'X')) then
			begin
			/*if	(nvl(ie_pre_analise_w,'N') = 'S') and
				((qt_grupo_aud_pre_w = 0) or (nr_seq_grupo_w = nr_seq_grupo_pre_analise_w)) then
				nr_seq_fluxo_w	:= 0;
			end if;*/

			
			/*Verifica se existe o grupo na analise */

			select	count(1)
			into STRICT	ie_existe_grupo_analise_w
			from	pls_auditoria_conta_grupo a
			where	a.nr_seq_analise	= nr_seq_analise_p
			and	a.nr_seq_grupo		= nr_seq_grupo_w  LIMIT 1;			
				
			if (ie_existe_grupo_analise_w > 0) then
				ds_conta_w := ds_conta_w || ',' || to_char(nr_seq_conta_p); /* Se existir o grupo concatena o numero da conta no DS_CONTA */

				
				/*if	(nvl(ie_pre_analise_w,'N') = 'S') then 
					update	pls_auditoria_conta_grupo
					set	nr_seq_ordem	= nr_seq_fluxo_w,
						ie_pre_analise	= ie_pre_analise_w
					where	nr_seq_grupo	= nr_seq_grupo_w;
				end if;*/
			else
				if (coalesce(nr_seq_fluxo_w::text, '') = '') then
					select	max(a.nr_seq_fluxo_padrao)
					into STRICT	nr_seq_fluxo_w
					from	pls_grupo_auditor	a
					where	a.nr_sequencia	= nr_seq_grupo_w;
				end if;
				
				select	min(nr_sequencia)
				into STRICT	nr_seq_grupo_ww
				from 	pls_auditoria_conta_grupo
				where	nr_seq_analise	= nr_seq_analise_p
				and	nr_seq_ordem	= nr_seq_fluxo_w;
				
				/*Diego OS 457916 - Historico 19/07/2012 16:27:06 - Nao deve alterar a ordem cadastrada na ocorrencia mesmo que exista mais de um grupo com a mesma ordem.
				while (nvl(nr_seq_grupo_ww,0) <> 0) loop 
					begin
					nr_seq_fluxo_w := nr_seq_fluxo_w + 1;
					
					select	min(nr_sequencia)
					into	nr_seq_grupo_ww
					from 	pls_auditoria_conta_grupo
					where	nr_seq_analise	= nr_seq_analise_p
					and	nr_seq_ordem	= nr_seq_fluxo_w;
					end;
				end loop;*/

				
				/*Se nao existir cria-se o grupo*/

				select	nextval('pls_auditoria_conta_grupo_seq')
				into STRICT	nr_seq_grupo_auditor_w
				;
				
				insert into pls_auditoria_conta_grupo(nr_sequencia,
					nr_seq_analise,
					nr_seq_grupo,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_ordem,
					ds_conta,
					ie_pre_analise)
				values (nr_seq_grupo_auditor_w,
					nr_seq_analise_p,
					nr_seq_grupo_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_fluxo_w,
					to_char(nr_seq_conta_p),
					'N');
					
				update	pls_analise_conta
				set	ie_auditoria	= 'S'
				where	nr_sequencia	= nr_seq_analise_p;
			end if;
			end;
		end if;
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
-- REVOKE ALL ON PROCEDURE pls_gerar_grupo_aud_conta ( nr_seq_conta_p bigint, nr_seq_analise_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
