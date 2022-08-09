-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pat_gerar_transf_docto ( nr_sequencia_p bigint, nm_usuario_p text, dt_referencia_p timestamp default clock_timestamp()) AS $body$
DECLARE


dt_transferencia_w	timestamp;
ds_erro_w		varchar(255);
qt_resp_aprov_w		bigint;
qt_existe_w		integer;
cd_bem_w		varchar(20);

c01 CURSOR FOR
	SELECT	a.nr_seq_bem,
		b.nr_seq_local,
		b.nr_seq_tipo,
		a.nr_seq_regra_conta,
		c.cd_conta_contabil,
		a.nr_seq_trans_financ
	FROM pat_doc_transferencia b, pat_transf_bem a
LEFT OUTER JOIN pat_conta_contabil c ON (a.nr_seq_regra_conta = c.nr_sequencia)
WHERE a.nr_seq_doc_transf = b.nr_sequencia  and b.nr_sequencia = nr_sequencia_p;

c01_w		c01%rowtype;


BEGIN

dt_transferencia_w	:= coalesce(dt_referencia_p,clock_timestamp());

select	count(nr_sequencia)
into STRICT	qt_resp_aprov_w
from	pat_doc_transf_resp
where 	nr_seq_doc_transf = nr_sequencia_p;

if (qt_resp_aprov_w > 0) then

	select	count(nr_sequencia)
	into STRICT	qt_resp_aprov_w
	from	pat_doc_transf_resp
	where 	nr_seq_doc_transf = nr_sequencia_p
	and 	coalesce(dt_aprovacao::text, '') = '';

	if (qt_resp_aprov_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(290848);
	end if;
end if;

select	count(*)
into STRICT	qt_existe_w
from	pat_transf_bem
where	nr_seq_doc_transf = nr_sequencia_p;

if (qt_existe_w = 0) then
	--r.aise_application_error(-20011, 'Nenhum bem a ser transferido neste documento.');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(210214);
end if;

open c01;
loop
FETCH C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	ds_erro_w := gerar_transf_patrimonio(c01_w.nr_seq_bem, dt_transferencia_w, c01_w.nr_seq_local, c01_w.cd_conta_contabil, c01_w.nr_seq_regra_conta, c01_w.nr_seq_trans_financ, nm_usuario_p, ds_erro_w, null, c01_w.nr_seq_tipo, 'N');
	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
		--r.aise_application_error(-20011, ds_erro_w);
		CALL wheb_mensagem_pck.exibir_mensagem_abort(210215,'DS_ERRO_W='||ds_erro_w);
	end if;

	select	coalesce(max(cd_bem),'0')
	into STRICT	cd_bem_w
	from	pat_bem
	where	nr_sequencia	= c01_w.nr_seq_bem;

	select	count(*)
	into STRICT	qt_existe_w
	from	man_equipamento
	where	cd_imobilizado = cd_bem_w;

	if (qt_existe_w > 0) then
		CALL gerar_transf_equipamento(cd_bem_w, c01_w.nr_seq_bem, nm_usuario_p, c01_w.nr_seq_local, null, null);
	end if;

END LOOP;
CLOSE C01;

update	pat_doc_transferencia
set	dt_transferencia = dt_transferencia_w
where	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pat_gerar_transf_docto ( nr_sequencia_p bigint, nm_usuario_p text, dt_referencia_p timestamp default clock_timestamp()) FROM PUBLIC;
