-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_venc_lote_pag ( nr_seq_lote_p bigint, nm_usuario_p text, cd_tributo_erro_p INOUT text, ds_lista_titulos_p INOUT text, ds_lista_repasses_p INOUT text, ds_lista_notas_p INOUT text, ds_listas_pag_prest_p INOUT text) AS $body$
DECLARE


nr_seq_pagamento_w		bigint;
ds_lista_titulos_w		varchar(255);
ds_lista_repasses_w		varchar(255);
ds_lista_notas_w		varchar(255);
ds_listas_pag_prest_w		varchar(255);

ds_lista_titulos_aux_w		varchar(255);
ds_lista_repasses_aux_w		varchar(255);
ds_lista_notas_aux_w		varchar(255);
ds_listas_pag_prest_aux_w	varchar(255);
cd_tributo_erro_aux_w		pls_pag_prest_venc_trib.cd_tributo%type;

cd_tributo_erro_w		varchar(255);
ie_possui_trib_ant_w		boolean;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_pagamento_prestador	a
	where	a.nr_seq_lote	= nr_seq_lote_p;


BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then

	ie_possui_trib_ant_w	:= false;

	open C01;
	loop
	fetch C01 into
		nr_seq_pagamento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		SELECT * FROM pls_desfazer_venc_pag_prest(nr_seq_pagamento_w, nm_usuario_p, cd_tributo_erro_aux_w, ds_lista_titulos_aux_w, ds_lista_repasses_aux_w, ds_lista_notas_aux_w, ds_listas_pag_prest_aux_w) INTO STRICT cd_tributo_erro_aux_w, ds_lista_titulos_aux_w, ds_lista_repasses_aux_w, ds_lista_notas_aux_w, ds_listas_pag_prest_aux_w;

		if (cd_tributo_erro_aux_w IS NOT NULL AND cd_tributo_erro_aux_w::text <> '') then
			ie_possui_trib_ant_w	:= true;
			ds_lista_titulos_w	:= substr(ds_lista_titulos_w || ',' || ds_lista_titulos_aux_w || ',',1,255);
			ds_lista_repasses_w	:= substr(ds_lista_repasses_w || ',' || ds_lista_repasses_aux_w || ',',1,255);
			ds_lista_notas_w	:= substr(ds_lista_notas_w || ',' || ds_lista_notas_aux_w || ',',1,255);
			ds_listas_pag_prest_w	:= substr(ds_listas_pag_prest_w || ',' || ds_listas_pag_prest_aux_w || ',',1,255);
			cd_tributo_erro_w	:= substr(cd_tributo_erro_w || ',' || cd_tributo_erro_aux_w || ',',1,255);
			rollback;
		end if;
		end;
	end loop;
	close C01;
end if;

if (not ie_possui_trib_ant_w) then

	-- jtonon - OS 837385 - Exlui backup das tabelas  /  TRIBUTO para PLS_TRIBUTO_LOG  /  TRIBUTO_CONTA_PAGAR para PLS_TRIB_CONTA_PAGAR_LOG  /  REGRA_CALCULO_IRPF para PLS_REGRA_CALCULO_IRPF_LOG
	CALL pls_desfazer_log_trib_pagto(nr_seq_lote_p);

	CALL pls_desfazer_even_movto_aprop(nr_seq_lote_p, nm_usuario_p);

	update	pls_lote_pagamento
	set	dt_geracao_vencimentos	 = NULL
	where	nr_sequencia		= nr_seq_lote_p;

	commit;
else
	rollback;
end if;

ds_lista_titulos_p	:= substr(ds_lista_titulos_w,1,255);
ds_lista_repasses_p	:= substr(ds_lista_repasses_w,1,255);
ds_lista_notas_p	:= substr(ds_lista_notas_w,1,255);
ds_listas_pag_prest_p	:= substr(ds_listas_pag_prest_w,1,255);
cd_tributo_erro_p	:= substr(cd_tributo_erro_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_venc_lote_pag ( nr_seq_lote_p bigint, nm_usuario_p text, cd_tributo_erro_p INOUT text, ds_lista_titulos_p INOUT text, ds_lista_repasses_p INOUT text, ds_lista_notas_p INOUT text, ds_listas_pag_prest_p INOUT text) FROM PUBLIC;

