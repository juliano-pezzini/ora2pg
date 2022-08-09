-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_estornar_ult_cont_insp ( nr_seq_contagem_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* ie_opcao_p
L -  Liberar;
E -  Estornar;
*/
ie_consiste_qtde_lote_w			varchar(1);
qt_inspecao_w				double precision;
qt_lote_w					double precision;
qt_marca_nao_aprov_w			bigint;
ie_consiste_marca_w			varchar(1);


BEGIN

select	coalesce(max(obter_valor_param_usuario(270, 52, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)),'N'),
	coalesce(max(obter_valor_param_usuario(270, 71, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)),'N')
into STRICT	ie_consiste_qtde_lote_w,
	ie_consiste_marca_w
;

if (ie_opcao_p = 'L') then

	select	coalesce(max(qt_inspecao),0)
	into STRICT	qt_inspecao_w
	from	inspecao_contagem
	where	nr_sequencia = nr_seq_contagem_p;

	if (qt_inspecao_w > 0) then

		select	coalesce(sum(qt_material),0)
		into STRICT	qt_lote_w
		from	inspecao_receb_lote_cont
		where	nr_seq_contagem = nr_seq_contagem_p;

		if (qt_lote_w > 0) and (qt_lote_w <> qt_inspecao_w) then
			/*A quantidade da contagem é diferente da soma das quantidades do lote.*/

			CALL wheb_mensagem_pck.exibir_mensagem_abort(211255);
		end if;
	end if;

	if (ie_consiste_marca_w = 'S') then
		begin

		select	count(*)
		into STRICT	qt_marca_nao_aprov_w
		from	inspecao_receb_lote_cont a,
			inspecao_contagem b,
			material_marca c
		where	a.nr_seq_contagem = nr_seq_contagem_p
		and	b.nr_sequencia = a.nr_seq_contagem
		and	c.cd_material = b.cd_material
		and	c.nr_sequencia = a.nr_seq_marca
		and	c.nr_seq_status_aval	> 0
		and	obter_tipo_status_aval_marca(c.nr_seq_status_aval) <> 'A';

		if (qt_marca_nao_aprov_w > 0) then
			/*Existem lotes com marca não aprovada (Parâmetro [71]).*/

			CALL wheb_mensagem_pck.exibir_mensagem_abort(211256);
		end if;

		end;
	end if;


end if;

update	inspecao_contagem
set	dt_liberacao = clock_timestamp(),
	nm_usuario_lib = nm_usuario_p
where	nr_sequencia = nr_seq_contagem_p
and	ie_opcao_p = 'L';

update	inspecao_contagem
set	dt_liberacao  = NULL,
	nm_usuario_lib  = NULL
where	nr_sequencia = nr_seq_contagem_p
and	ie_opcao_p = 'E';

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_estornar_ult_cont_insp ( nr_seq_contagem_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
