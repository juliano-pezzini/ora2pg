-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_escriturac_quota (nr_seq_cooperado_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ie_tipo_escrituracao_w		varchar(3);		
nr_sequencia_w			bigint;
nr_seq_tipo_escrit_quota_w	bigint;
dt_lancamento_w			timestamp;
nm_cooperado_w			varchar(255);
	

BEGIN 
if (nr_seq_cooperado_p IS NOT NULL AND nr_seq_cooperado_p::text <> '') then 
	select	coalesce(max(a.nr_sequencia),0) 
	into STRICT	nr_sequencia_w 
	from	pls_tipo_escrit_quota b, 
		pls_escrituracao_quota a 
	where	a.nr_seq_tipo_escrit_quota	= b.nr_sequencia 
	and (coalesce(a.dt_liberacao::text, '') = '') 
	and (a.nr_sequencia <> coalesce(nr_sequencia_p,0)) 
	and	a.nr_seq_cooperado = nr_seq_cooperado_p;
	 
	if (nr_sequencia_w > 0) then 
	 
		select	max(b.dt_lancamento), 
			substr(obter_nome_pf(a.cd_pessoa_fisica),1,255)	nm_cooperado	 
		into STRICT	dt_lancamento_w, 
			nm_cooperado_w 
		from	pls_escrituracao_quota b, 
			pls_cooperado a 
		where	a.nr_sequencia = b.nr_seq_cooperado 
		and	b.nr_sequencia = nr_sequencia_w 
		group by a.cd_pessoa_fisica;
	 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(267422, 
							'NM_COOPERADO_W=' || nm_cooperado_w||';'|| 
							'DT_LANCAMENTO_W=' || dt_lancamento_w);
	end if;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_escriturac_quota (nr_seq_cooperado_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
