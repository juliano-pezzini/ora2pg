-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_sib_reenvio_devolucao ( nr_seq_devolucao_erro_p pls_sib_devolucao_erro.nr_sequencia%type, ie_tipo_movimento_reenvio_p pls_sib_reenvio.ie_tipo_movimento%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

 
qt_registro_w		integer;
nr_seq_segurado_w	pls_sib_devolucao_erro.nr_seq_segurado%type;
nr_seq_devolucao_w	pls_sib_devolucao.nr_sequencia%type;
nr_seq_lote_sib_w	pls_sib_lote.nr_sequencia%type;


BEGIN 
 
select	count(1) 
into STRICT	qt_registro_w 
from	pls_sib_reenvio 
where	nr_seq_devolucao_erro	= nr_seq_devolucao_erro_p 
and	ie_tipo_movimento	= ie_tipo_movimento_reenvio_p 
and	coalesce(nr_seq_lote_sib::text, '') = '';
 
if (qt_registro_w > 0) then --Já existe re-envio de #@DS_TIPO_MOVIMENTO#@ pendente para o registro de devolução. Favor verifique. 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(834527,'DS_TIPO_MOVIMENTO='||obter_valor_dominio(8352,ie_tipo_movimento_reenvio_p));
else 
	select	max(nr_seq_segurado) 
	into STRICT	nr_seq_segurado_w 
	from	pls_sib_devolucao_erro 
	where	nr_sequencia	= nr_seq_devolucao_erro_p;
	 
	if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') and (ie_tipo_movimento_reenvio_p IS NOT NULL AND ie_tipo_movimento_reenvio_p::text <> '') then 
		select	max(nr_seq_devolucao) 
		into STRICT	nr_seq_devolucao_w 
		from	pls_sib_devolucao_erro a 
		where	a.nr_seq_segurado	= nr_seq_segurado_w 
		and	a.nr_sequencia		<> nr_seq_devolucao_erro_p 
		and	exists (SELECT	1 
				from	pls_sib_reenvio x 
				where	x.nr_seq_devolucao_erro = a.nr_sequencia 
				and	coalesce(x.nr_seq_lote_sib::text, '') = '' 
				and	x.ie_tipo_movimento = ie_tipo_movimento_reenvio_p);
		 
		if (nr_seq_devolucao_w IS NOT NULL AND nr_seq_devolucao_w::text <> '') then 
			select	nr_seq_lote_sib 
			into STRICT	nr_seq_lote_sib_w 
			from	pls_sib_devolucao 
			where	nr_sequencia	= nr_seq_devolucao_w;
			 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(804100, 'BENEFICIARIO='||pls_obter_dados_segurado(nr_seq_segurado_w,'N') ||'('|| nr_seq_segurado_w ||')'|| 
									';NR_SEQ_DEVOLUCAO='||nr_seq_devolucao_w|| 
									';NR_SEQ_LOTE_SIB='||nr_seq_lote_sib_w);
		else 
			insert	into	pls_sib_reenvio(	nr_sequencia, nr_seq_devolucao_erro, ie_tipo_movimento, cd_estabelecimento, 
					dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
					nr_seq_segurado) 
				values (	nextval('pls_sib_reenvio_seq'), nr_seq_devolucao_erro_p, ie_tipo_movimento_reenvio_p, cd_estabelecimento_p, 
					clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 
					nr_seq_segurado_w);
		end if;
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sib_reenvio_devolucao ( nr_seq_devolucao_erro_p pls_sib_devolucao_erro.nr_sequencia%type, ie_tipo_movimento_reenvio_p pls_sib_reenvio.ie_tipo_movimento%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
