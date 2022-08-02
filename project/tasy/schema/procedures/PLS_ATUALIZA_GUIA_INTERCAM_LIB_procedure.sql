-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_guia_intercam_lib ( nr_seq_guia_p bigint, cd_senha_externa_p text, dt_validade_senha_p timestamp, ds_historico_p text, ie_tipo_liberacao_p text, nm_usuario_p text) AS $body$
DECLARE


/*
ie_tipo_liberacao_p
AU  - OPS - Autorizações
AN  - OPS - Gestão de análise de autorizações
*/
ie_estagio_w			numeric(20);
qt_itens_neg_w			numeric(20);
qt_proc_neg_w			numeric(20);
qt_mat_neg_w			numeric(20);
qt_itens_aprov_w		numeric(20);
qt_proc_aprov_w			numeric(20);
qt_mat_aprov_w			numeric(20);
ie_status_w			bigint;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
dt_solicitacao_w		pls_guia_plano.dt_solicitacao%type;
ie_tipo_guia_w			pls_guia_plano.ie_tipo_guia%type;
dt_validade_senha_w		pls_guia_plano.dt_validade_senha%type;
cd_senha_w			pls_guia_plano.cd_senha%type;
qt_item_w			double precision;

C01 CURSOR(nr_seq_guia_pc pls_guia_plano_proc.nr_seq_guia%type) FOR
	SELECT	nr_sequencia,
		qt_solicitada,
		qt_autorizada
	from	pls_guia_plano_proc
	where	nr_seq_guia	= nr_seq_guia_pc
	and	ie_status	= 'I';

C02 CURSOR(nr_seq_guia_pc pls_guia_plano_mat.nr_seq_guia%type) FOR
	SELECT	nr_sequencia,
		qt_solicitada,
		qt_autorizada
	from	pls_guia_plano_mat
	where	nr_seq_guia	= nr_seq_guia_pc
	and	ie_status	= 'I';
BEGIN

if (ie_tipo_liberacao_p = 'AN') then
	for r_C01_w in C01(nr_seq_guia_p) loop
		begin
			if (r_C01_w.qt_autorizada	> 0) then
				qt_item_w	:= r_C01_w.qt_autorizada;
			else
				qt_item_w	:= r_C01_w.qt_solicitada;
			end if;

			update	pls_guia_plano_proc
			set	ie_status		= 'P',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				qt_autorizada		= qt_item_w
			where	nr_sequencia		= r_C01_w.nr_sequencia;
		end;
	end loop;

	for r_C02_w in C02(nr_seq_guia_p) loop
		begin
			if (r_C02_w.qt_autorizada	> 0) then
				qt_item_w	:= r_C02_w.qt_autorizada;
			else
				qt_item_w	:= r_C02_w.qt_solicitada;
			end if;

			update	pls_guia_plano_mat
			set	ie_status		= 'P',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				qt_autorizada		= qt_item_w
			where	nr_sequencia		= r_C02_w.nr_sequencia;
		end;
	end loop;

elsif (ie_tipo_liberacao_p = 'AU') then
	for r_C01_w in C01(nr_seq_guia_p) loop
		begin
			if (r_C01_w.qt_autorizada	> 0) then
				qt_item_w	:= r_C01_w.qt_autorizada;
			else
				qt_item_w	:= r_C01_w.qt_solicitada;
			end if;

			update	pls_guia_plano_proc
			set	ie_status		= 'L',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				qt_autorizada		= qt_item_w
			where	nr_sequencia		= r_C01_w.nr_sequencia;
		end;
	end loop;

	for r_C02_w in C02(nr_seq_guia_p) loop
		begin
			if (r_C02_w.qt_autorizada	> 0) then
				qt_item_w	:= r_C02_w.qt_autorizada;
			else
				qt_item_w	:= r_C02_w.qt_solicitada;
			end if;

			update	pls_guia_plano_mat
			set	ie_status		= 'L',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				qt_autorizada		= qt_item_w
			where	nr_sequencia		= r_C02_w.nr_sequencia;
		end;
	end loop;
end if;

select	count(1)
into STRICT	qt_proc_aprov_w
from	pls_guia_plano_proc
where	nr_seq_guia		= nr_seq_guia_p
and	ie_status		in ('L','P');

select	count(1)
into STRICT	qt_mat_aprov_w
from	pls_guia_plano_mat
where	nr_seq_guia		= nr_seq_guia_p
and	ie_status		in ('L','P');

qt_itens_aprov_w	:= qt_proc_aprov_w + qt_mat_aprov_w;

select	count(1)
into STRICT	qt_proc_neg_w
from	pls_guia_plano_proc
where	nr_seq_guia		= nr_seq_guia_p
and	ie_status		in ('K','M','N');

select	count(1)
into STRICT	qt_mat_neg_w
from	pls_guia_plano_mat
where	nr_seq_guia		= nr_seq_guia_p
and	ie_status		in ('K','M','N');

select	nr_seq_segurado,
	dt_solicitacao,
	ie_tipo_guia
into STRICT	nr_seq_segurado_w,
	dt_solicitacao_w,
	ie_tipo_guia_w
from	pls_guia_plano
where	nr_sequencia	= nr_seq_guia_p;


qt_itens_neg_w	:= qt_proc_neg_w + qt_mat_neg_w;

if (qt_itens_aprov_w	> 0) and (qt_itens_neg_w	= 0) then
	ie_estagio_w	:= 6;
	ie_status_w	:= 1;
elsif (qt_itens_aprov_w	> 0) and (qt_itens_neg_w	> 0) then
	ie_estagio_w	:= 10;
	ie_status_w	:= 1;
elsif (qt_itens_aprov_w	= 0) and (qt_itens_neg_w	> 0) then
	ie_estagio_w	:= 4;
	ie_status_w	:= 3;
end if;

-- Djavan 09/07/2014 - OS683611
SELECT * FROM pls_gerar_validade_senha(	nr_seq_guia_p, nr_seq_segurado_w, null, dt_solicitacao_w, ie_tipo_guia_w, nm_usuario_p, dt_validade_senha_w, cd_senha_w) INTO STRICT dt_validade_senha_w, cd_senha_w;
-- fim
update	pls_guia_plano
set	ie_estagio		= ie_estagio_w,
	ie_status		= ie_status_w,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp(),
	ds_observacao		= substr(ds_historico_p,1,4000),
	cd_senha_externa	= cd_senha_externa_p,
	dt_validade_senha	= dt_validade_senha_p,
	dt_valid_senha_ext	= dt_validade_senha_p,
	dt_autorizacao		= clock_timestamp(),
	cd_senha		= cd_senha_w
where	nr_sequencia		= nr_seq_guia_p;

CALL pls_guia_gravar_historico(	nr_seq_guia_p, 2, substr('Realizada a liberação manual da guia de intercâmbio nº '||nr_seq_guia_p||
				' pelo usuário '||nm_usuario_p||' em '||to_char(clock_timestamp() , 'dd/mm/yyyy hh24:mi:ss')||' com a seguinte justificativa: '||
				ds_historico_p,1,4000), null, nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_guia_intercam_lib ( nr_seq_guia_p bigint, cd_senha_externa_p text, dt_validade_senha_p timestamp, ds_historico_p text, ie_tipo_liberacao_p text, nm_usuario_p text) FROM PUBLIC;

