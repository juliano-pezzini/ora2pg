-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_itens_caixa_opme_agenda (nr_seq_tipo_caixa_p bigint, nr_seq_pac_caixa_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_item_w		bigint;
qt_item_w		bigint;
ie_qt_zerado_w		varchar(1);
cd_perfil_w		bigint;
cd_estabelecimento_w	bigint;

c01 CURSOR FOR
	SELECT 	b.nr_sequencia,
		b.qt_item
	from   	opme_tipo_caixa a,
		opme_tipo_caixa_item b
	where  	a.nr_sequencia = b.nr_seq_tipo
	and	a.nr_sequencia = nr_seq_tipo_caixa_p;


BEGIN

cd_perfil_w		:=	obter_perfil_ativo;
cd_estabelecimento_w	:= 	wheb_usuario_pck.get_cd_estabelecimento;

ie_qt_zerado_w := Obter_Param_Usuario(871, 801, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_qt_zerado_w);


if (coalesce(nr_seq_pac_caixa_p,0) > 0) and (coalesce(nr_seq_tipo_caixa_p,0) > 0) then
	if (ie_acao_p = 'I') then -- Insert
		open c01;
		loop
		fetch c01 into
			nr_seq_item_w,
			qt_item_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			insert	into	agenda_pac_caixa_item(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_pac_caixa,
						nr_seq_item,
						qt_utilizada)
			values (nextval('agenda_pac_caixa_item_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_pac_caixa_p,
						nr_seq_item_w,
						CASE WHEN ie_qt_zerado_w='S' THEN 0  ELSE qt_item_w END );
		end loop;
		close c01;
	elsif (ie_acao_p = 'D') then -- Delete
		delete from agenda_pac_caixa_item where nr_seq_pac_caixa = nr_seq_pac_caixa_p;
	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_itens_caixa_opme_agenda (nr_seq_tipo_caixa_p bigint, nr_seq_pac_caixa_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;

