-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desdobrar_contagem_inspecao ( nr_seq_registro_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* Inspeção Contagem */

cd_condicao_pagamento_w        	bigint;
ds_justificativa_w             		varchar(2000);
ds_observacao_w                 		varchar(2000);
dt_entrega_real_w               		timestamp;
nr_seq_tipo_nao_conf_w          	bigint;
ie_externo_w                    		varchar(3);
ie_interno_w                    		varchar(3);
ie_laudo_w                      		varchar(1);
ie_motivo_devolucao_w           	varchar(2);
ie_temperatura_w                		varchar(20);
pr_desconto_w                   		double precision;
qt_inspecao_w                   		double precision;
vl_desconto_w                   		double precision;
vl_unitario_material_w          		double precision;
nr_seq_contagem_w               	bigint;
nr_seq_inspecao_w               		bigint;
nr_seq_insp_contagem_w          	bigint;
qt_registro_w			bigint;
ds_erro_w			varchar(255);
nr_seq_marca_w			inspecao_contagem.nr_seq_marca%type;

/* Inspeção Recebimento */

C01 CURSOR FOR
SELECT	distinct
	nr_sequencia
from    inspecao_recebimento
where   nr_seq_registro = nr_seq_registro_p
order by	nr_sequencia;

/* Inspeção Contagem */

C02 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_seq_inspecao,
	a.cd_condicao_pagamento,
	a.ds_justificativa,
	a.ds_observacao,
	a.dt_entrega_real,
	a.nr_seq_tipo_nao_conf,
	a.ie_externo,
	a.ie_interno,
	a.ie_laudo,
	a.ie_motivo_devolucao,
	a.ie_temperatura,
	a.pr_desconto,
	a.qt_inspecao,
	a.vl_desconto,
	a.vl_unitario_material,
	a.nr_seq_marca
from    inspecao_contagem a
where   a.nr_seq_registro = nr_seq_registro_p
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and     a.nr_seq_contagem = 2
and not exists (
	SELECT	1
	from	inspecao_contagem x
	where	x.nr_seq_inspecao 	= a.nr_seq_inspecao
	and	x.nr_seq_contagem		= 3)

union

select	a.nr_sequencia,
	a.nr_seq_inspecao,
	a.cd_condicao_pagamento,
	a.ds_justificativa,
	a.ds_observacao,
	a.dt_entrega_real,
	a.nr_seq_tipo_nao_conf,
	a.ie_externo,
	a.ie_interno,
	a.ie_laudo,
	a.ie_motivo_devolucao,
	a.ie_temperatura,
	a.pr_desconto,
	a.qt_inspecao,
	a.vl_desconto,
	a.vl_unitario_material,
	a.nr_seq_marca
from    inspecao_contagem a
where   a.nr_seq_registro = nr_seq_registro_p
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and     a.nr_seq_contagem = 3
order by	nr_seq_inspecao;


BEGIN

/* Verifica se todas as Segundas Contagens estão liberadas */

open C01;
loop
fetch C01 into
	nr_seq_inspecao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (obter_se_contagem_liberada(nr_seq_registro_p, nr_seq_inspecao_w, 2) = 'N') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(265964,'NR_SEQ_REGISTRO=' || nr_seq_inspecao_w);
		--'É necessário gerar e liberar  todas as 2ª contagens do registro ' || nr_seq_registro_p || '.' || chr(13) || chr(10) ||
		--'Pasta -> Contagem Inspeção.'
	end if;

	select	count(*)
	into STRICT	qt_registro_w
	from	inspecao_contagem
	where	nr_seq_inspecao = nr_seq_inspecao_w
	and	nr_seq_contagem	= 3;

	if (qt_registro_w > 0) and (obter_se_contagem_liberada(nr_seq_registro_p, nr_seq_inspecao_w, 3) = 'N') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(265967,'NR_SEQ_REGISTRO=' || nr_seq_inspecao_w);
		--'É necessário gerar e liberar  todas as 3ª contagens do registro ' || nr_seq_registro_p || '.' || chr(13) || chr(10) ||
		--'Pasta -> Última contagem.'
	end if;
	end;
end loop;
close C01;


begin -- begin Exception
delete  FROM inspecao_recebimento_lote
where   nr_seq_inspecao in (	SELECT	nr_sequencia
				from    inspecao_recebimento
				where   nr_seq_registro = nr_seq_registro_p);
exception
when others then
	ds_erro_w := '';
end; -- end Exception
/* Inspeção Contagem */

open C02;
loop
fetch C02 into
	nr_seq_insp_contagem_w,
	nr_seq_inspecao_w,
	cd_condicao_pagamento_w,
	ds_justificativa_w,
	ds_observacao_w,
	dt_entrega_real_w,
	nr_seq_tipo_nao_conf_w,
	ie_externo_w,
	ie_interno_w,
	ie_laudo_w,
	ie_motivo_devolucao_w,
	ie_temperatura_w,
	pr_desconto_w,
	qt_inspecao_w,
	vl_desconto_w,
	vl_unitario_material_w,
	nr_seq_marca_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	begin --Inicio exception
	update	inspecao_recebimento
	set	cd_condicao_pagamento 	= cd_condicao_pagamento_w,
		ds_justificativa 		= ds_justificativa_w,
		ds_observacao			= ds_observacao_w,
		dt_entrega_real			= dt_entrega_real_w,
		nr_seq_tipo_nao_conf	= nr_seq_tipo_nao_conf_w,
		ie_externo				= coalesce(ie_externo_w, 'N'),
		ie_interno				= coalesce(ie_interno_w, 'N'),
		ie_laudo				= coalesce(ie_laudo_w, 'N'),
		ie_motivo_devolucao		= ie_motivo_devolucao_w,
		ie_temperatura			= ie_temperatura_w,
		pr_desconto				= pr_desconto_w,
		qt_inspecao				= qt_inspecao_w,
		vl_desconto				= vl_desconto_w,
		vl_unitario_material	= vl_unitario_material_w,
		nr_seq_marca			= nr_seq_marca_w
	where	nr_sequencia 		= nr_seq_inspecao_w;

	/* Inspeção Recebimento Lote */

	insert into inspecao_recebimento_lote(
			nr_sequencia,
			cd_barra_material,
			cd_lote_fabricacao,
			ds_barras,
			dt_atualizacao,
			dt_atualizacao_nrec,
			dt_fabricacao,
			dt_validade,
			ie_indeterminada,
			nm_usuario,
			nm_usuario_nrec,
			nr_seq_inspecao,
			nr_seq_marca,
			qt_material)
	SELECT		nextval('inspecao_recebimento_lote_seq'), /* Inspeção Contagem Lote */
			cd_barra_material,
			cd_lote_fabricacao,
			ds_barras,
			clock_timestamp(),
			clock_timestamp(),
			dt_fabricacao,
			dt_validade,
			ie_indeterminada,
			nm_usuario_p,
			nm_usuario_p,
			nr_seq_inspecao_w,
			nr_seq_marca,
			qt_material
	from		inspecao_receb_lote_cont
	where		nr_seq_contagem = nr_seq_insp_contagem_w;

	exception when others then
		ds_erro_w	:= substr(sqlerrm,1,255);
	end; -- Fim exception
	end;
end loop;
close C02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desdobrar_contagem_inspecao ( nr_seq_registro_p bigint, nm_usuario_p text) FROM PUBLIC;
