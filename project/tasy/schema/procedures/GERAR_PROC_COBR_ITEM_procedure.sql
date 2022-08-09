-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_proc_cobr_item (nr_seq_processo_p bigint, nr_seq_cobranca_p bigint, nm_usuario_p text, ie_commit_p text default 'S') AS $body$
DECLARE


vl_tot_original_w			cobranca.vl_original%type;
vl_tot_acobrar_w			cobranca.vl_acobrar%type;
vl_tot_acrescimos_w			cobranca.vl_acobrar%type;
vl_tot_perdas_w				cobranca.vl_original%type;


BEGIN

insert	into processo_cobr_item(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_processo,
	nr_seq_cobranca)
values (nextval('processo_cobr_item_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_processo_p,
	nr_seq_cobranca_p);

--OS 1636767 Atualizar os valores do processo cobranca sempre ao incluir uma nova cobrança em processo.
select	coalesce(sum(vl_original),0),
		coalesce(sum(vl_acobrar),0),
		coalesce(sum(vl_acobrar + coalesce(obter_juros_multa_titulo(a.nr_titulo,clock_timestamp(),'R','A'),0)),0),
		coalesce(sum(CASE WHEN b.ie_situacao='6' THEN a.vl_original  ELSE 0 END ),0)
into STRICT	vl_tot_original_w,
		vl_tot_acobrar_w,
		vl_tot_acrescimos_w,
		vl_tot_perdas_w
FROM processo_cobr_item c, cobranca a
LEFT OUTER JOIN titulo_receber b ON (a.nr_titulo = b.nr_titulo)
WHERE a.nr_sequencia 		= c.nr_seq_cobranca and c.nr_seq_processo	= nr_seq_processo_p;

update	processo_cobranca
set		vl_original		= coalesce(vl_tot_original_w,0),
		vl_acobrar		= coalesce(vl_tot_acobrar_w,0),
		vl_cobranca		= coalesce(vl_tot_acrescimos_w,0),
		vl_perda		= coalesce(vl_tot_perdas_w,0)
where	nr_sequencia	= nr_seq_processo_p;

if (coalesce(ie_commit_p,'S') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_proc_cobr_item (nr_seq_processo_p bigint, nr_seq_cobranca_p bigint, nm_usuario_p text, ie_commit_p text default 'S') FROM PUBLIC;
