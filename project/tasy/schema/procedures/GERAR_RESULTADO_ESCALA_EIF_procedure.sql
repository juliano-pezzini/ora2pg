-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_resultado_escala_eif ( nr_sequencia_p bigint) AS $body$
DECLARE



qt_total_w		double precision;
nr_seq_item_w		bigint;
nr_seq_result_w		bigint;
ie_resultado_w		varchar(2) := 'N';
qt_resultado_w		bigint := 0;
qt_registro_w		bigint := 0;
sql_w           varchar(300);
C01 CURSOR FOR
	SELECT	a.nr_seq_item
	from	eif_escala_result_regra a,
		eif_escala_result b,
		escala_eif c
	where	a.nr_seq_result = b.nr_sequencia
	and	c.nr_sequencia = nr_sequencia_p
	and	b.nr_seq_escala = c.nr_seq_escala
	order by a.nr_seq_item;


BEGIN

    select	coalesce(sum(CASE WHEN a.ie_resultado='S' THEN b.qt_pontos_pos  ELSE b.qt_pontos_neg END ),0)
    into STRICT	qt_total_w
    from	escala_eif_item a,
        eif_escala_item b
    where	a.nr_seq_escala = nr_sequencia_p
    and	b.nr_sequencia = a.nr_seq_item;

    open C01;
    loop
    fetch C01 into
        nr_seq_item_w;
    EXIT WHEN NOT FOUND; /* apply on C01 */
        begin

        select 	a.ie_resultado
        into STRICT	ie_resultado_w
        from	escala_eif_item a,
            eif_escala_item b
        where	a.nr_seq_escala = nr_sequencia_p
        and	b.nr_sequencia = a.nr_seq_item
        and	a.nr_Seq_item = nr_seq_item_w;

      
        begin
        sql_w := 'BEGIN OBTER_RESULT_REGISTRO_EIF_MD(:1, :2, :3); END;';

        EXECUTE sql_w USING IN ie_resultado_w,
                                      IN OUT qt_resultado_w,
                                      IN OUT qt_registro_w;
        exception
          when others then
            qt_resultado_w    := null;
            qt_registro_w     := null;
        end;

        
        end;
    end loop;
    close C01;


      begin
      sql_w := 'CALL OBTER_IE_RESULTADO_EIF_MD(:1,:2) INTO :ie_resultado_w';
          EXECUTE sql_w USING IN qt_resultado_w,
                                        IN qt_registro_w,
                                        OUT ie_resultado_w;

      exception
        when others then
          ie_resultado_w := null;
      end;


    select	max(coalesce(a.nr_sequencia,0))
    into STRICT	nr_seq_result_w
    from 	eif_escala_result a,
            escala_eif b
    where	b.nr_sequencia = nr_sequencia_p
    and	a.nr_seq_escala = b.nr_seq_escala
    and	qt_total_w between a.qt_pontos_min and a.qt_pontos_max
    and	(((ie_resultado_w = 'S') and exists (	SELECT 	1
                            from	eif_escala_result_regra x
                            where	x.nr_seq_result = a.nr_sequencia))
        or ((ie_resultado_w = 'N') and not exists ( 	SELECT 	1
                            from	eif_escala_result_regra x
                            where	x.nr_seq_result = a.nr_sequencia)));

    
    update	escala_eif
    set	nr_seq_result	= 	nr_seq_result_w
    where	nr_sequencia 	= 	nr_sequencia_p;

    if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then
      commit;
    end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_resultado_escala_eif ( nr_sequencia_p bigint) FROM PUBLIC;
