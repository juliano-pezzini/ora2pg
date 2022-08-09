-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_ajustar_fatura_pcmso ( nr_seq_fatura_p ptu_fatura.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE


ie_pcmso_w			varchar(5);
ie_pcmso_fatura_w		varchar(5);

c01 CURSOR(	nr_seq_fatura_pc	ptu_fatura.nr_sequencia%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type) FOR
	-- Importacao de A500 (OPS - Contas de Intercambio (A500))
	SELECT	pls_obter_segurado_carteira( lpad(cd_unimed,4,'0') || cd_usuario_plano, cd_estabelecimento_pc) nr_seq_segurado
	from	ptu_nota_cobranca	fc,
		ptu_fatura		ft
	where	ft.nr_sequencia	= fc.nr_seq_fatura
	and	ft.nr_sequencia	= nr_seq_fatura_pc
	and	coalesce(ft.nr_seq_pls_fatura::text, '') = ''
	
union

	-- Exportacao de A500 (OPS - Faturamento)
	SELECT	fc.nr_seq_segurado
	from	pls_fatura_conta	fc,
		pls_fatura_evento	fe,
		pls_fatura		fl,
		ptu_fatura		ft
	where	fl.nr_sequencia	= ft.nr_seq_pls_fatura
	and	fl.nr_sequencia	= fe.nr_seq_fatura
	and	fe.nr_sequencia	= fc.nr_seq_fatura_evento
	and	ft.nr_sequencia	= nr_seq_fatura_pc
	and	(ft.nr_seq_pls_fatura IS NOT NULL AND ft.nr_seq_pls_fatura::text <> '');
	
BEGIN

CALL pls_grava_log_proces_imp_a500('Inicio ptu_ajustar_fatura_pcmso', nr_seq_fatura_p, nm_usuario_p);

if (coalesce(nr_seq_segurado_p::text, '') = '') then
	for r_c01_w in c01( nr_seq_fatura_p, cd_estabelecimento_p ) loop		
		begin
		select	ie_pcmso
		into STRICT	ie_pcmso_w
		from	pls_segurado
		where	nr_sequencia	= r_c01_w.nr_seq_segurado;
		exception
		when others then
			ie_pcmso_w := ie_pcmso_w;
		end;
		
		if (coalesce(ie_pcmso_w,'N') = 'N') then
			ie_pcmso_fatura_w := 'N';
		end if;		
	end loop;

elsif (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
	begin
	select	ie_pcmso
	into STRICT	ie_pcmso_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;
	exception
	when others then
		ie_pcmso_w := ie_pcmso_w;
	end;
	
	if (coalesce(ie_pcmso_w,'N') = 'N') then
		ie_pcmso_fatura_w := 'N';
	end if;	
end if;

if (coalesce(ie_pcmso_fatura_w,'S') = 'N') then
	ie_pcmso_w := 'N';
end if;

update	ptu_fatura
set	ie_pcmso	= coalesce(ie_pcmso_w,'N')
where	nr_sequencia	= nr_seq_fatura_p;

if (coalesce(ie_commit_p,'S') = 'S') then
	commit;
end if;

CALL pls_grava_log_proces_imp_a500('Fim ptu_ajustar_fatura_pcmso', nr_seq_fatura_p, nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_ajustar_fatura_pcmso ( nr_seq_fatura_p ptu_fatura.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;
