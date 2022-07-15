-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_pontuacao_auditoria ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE



ie_resultado_W		varchar(3);
vl_item_w		double precision;
qt_total_ponto_w	double precision := 0;
cd_estabelecimento_w	smallint := Wheb_Usuario_pck.get_cd_estabelecimento;
qt_valor_parcial_w	real := 1;

C01 CURSOR FOR
	SELECT	c.ie_resultado,
		b.vl_item
	from	qua_auditoria_result c,
		qua_auditoria_item b,
		qua_auditoria_estrut a,
		qua_auditoria d
	where	b.nr_seq_estrutura	= a.nr_sequencia
	and	d.nr_sequencia		= c.nr_seq_auditoria
	and	d.nr_seq_tipo		= a.nr_seq_tipo
	and	c.nr_seq_item		= b.nr_sequencia
	and (SELECT count(*) from qua_auditoria_subitem x where x.nr_seq_item = b.nr_sequencia) = 0
	and	d.nr_sequencia		= nr_sequencia_p
	and	(c.ie_resultado IS NOT NULL AND c.ie_resultado::text <> '')

union all

        select	c.ie_resultado,
                b.vl_item / (select count(*) from qua_auditoria_subitem x where x.nr_seq_item = b.nr_sequencia)
	from	qua_auditoria_result c,
		qua_auditoria_item b,
		qua_auditoria_estrut a,
		qua_auditoria d,
                qua_auditoria_subitem e
	where	b.nr_seq_estrutura	= a.nr_sequencia
	and	d.nr_sequencia		= c.nr_seq_auditoria
	and	d.nr_seq_tipo		= a.nr_seq_tipo
	and	c.nr_seq_item		= b.nr_sequencia
        and     e.nr_sequencia          = c.nr_seq_subitem
	and	d.nr_sequencia		= nr_sequencia_p
	and	(c.ie_resultado IS NOT NULL AND c.ie_resultado::text <> '');


BEGIN
qt_total_ponto_w	:= 0;

qt_valor_parcial_w := obter_param_usuario(4000, 224, obter_perfil_Ativo, nm_usuario_p, cd_estabelecimento_w, qt_valor_parcial_w);

begin
qt_valor_parcial_w := dividir(coalesce(qt_valor_parcial_w,100),100);
exception
when others then
	qt_valor_parcial_w := 1;
end;


OPEN C01;
LOOP
FETCH C01 into
	ie_resultado_W,
	vl_item_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	if (ie_resultado_W not in ('NC','NA','PC')) then
		qt_total_ponto_w	:= qt_total_ponto_w + vl_item_w;
	elsif (ie_resultado_W = 'PC') then
		qt_total_ponto_w	:= qt_total_ponto_w + (vl_item_w * qt_valor_parcial_w);
	end if;
END LOOP;
close C01;

update	qua_auditoria
set	vl_total		= qt_total_ponto_w
where	nr_sequencia	= nr_sequencia_p;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_pontuacao_auditoria ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

