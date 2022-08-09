-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dar_prepara_sql_grafico ( nr_sequencia_p dar_dashboard.nr_sequencia%type, ds_sql_p INOUT text, ie_tab bigint ) AS $body$
DECLARE


   Dominio       CONSTANT bigint := 10009;
   Dominio_Where CONSTANT bigint := 10048;

   c1 CURSOR FOR
      SELECT DISTINCT b.ds_app,
             CASE WHEN CASE WHEN ie_tab=0 THEN  a.nr_seq_dimensao WHEN ie_tab=1 THEN  i.nr_seq_dimensao (END IS NOT NULL AND END::text <> '') THEN d.nr_identificador ELSE NULL END nr_seq_dimensao,
             e.nr_identificador nr_seq_quantitativo,
             CASE WHEN CASE WHEN ie_tab=0 THEN  a.nr_seq_dimensao WHEN ie_tab=1 THEN  i.nr_seq_dimensao (END IS NOT NULL AND END::text <> '') THEN coalesce(d.ds_expressao_campo, d.ds_campo) ELSE NULL END ds_campo_x,
             coalesce(e.ds_expressao_campo, e.ds_campo) ds_campo_y,
             CASE WHEN ie_tab=0 THEN  a.ie_operacao WHEN ie_tab=1 THEN  i.ie_operacao END  ie_operacao,
             c.nm_tabela,
             h.ds_valor_dominio
        from dar_dashboard          a,
             dar_app                b,
             dar_tables_control     c,
             dar_tab_control_fields d,
             dar_tab_control_fields e,
             dar_app_datamodels     f,
             dominio                g,
             valor_dominio          h,
             dar_dashboard_tabs     i
       where CASE WHEN ie_tab=0 THEN  a.nr_sequencia WHEN ie_tab=1 THEN  i.nr_sequencia END  = nr_sequencia_p
         and b.nr_sequencia = a.nr_seq_app
         and c.nr_sequencia = d.nr_seq_table_control
         and ((CASE WHEN ie_tab=0 THEN  a.nr_seq_dimensao WHEN ie_tab=1 THEN  i.nr_seq_dimensao (END IS NOT NULL AND END::text <> '') AND d.nr_sequencia = CASE WHEN ie_tab=0 THEN  a.nr_seq_dimensao WHEN ie_tab=1 THEN  i.nr_seq_dimensao END ) OR CASE WHEN ie_tab=0 THEN  a.nr_seq_dimensao WHEN ie_tab=1 THEN  i.nr_seq_dimensao coalesce(END::text, '') = '')
         and e.nr_sequencia = CASE WHEN ie_tab=0 THEN  a.nr_seq_quantitativo WHEN ie_tab=1 THEN  i.nr_seq_quantitativo END
         and f.nr_seq_app = b.nr_sequencia
         and c.nr_sequencia = f.nr_seq_table_control
         and g.cd_dominio = Dominio
         and g.cd_dominio = h.cd_dominio
         and h.vl_dominio = CASE WHEN ie_tab=0 THEN  a.ie_operacao WHEN ie_tab=1 THEN  i.ie_operacao END 
         and ((ie_tab = 1 and i.nr_seq_dashboard = a.nr_sequencia) or (ie_tab = 0 and coalesce(i.nr_sequencia::text, '') = ''));

   r1 c1%rowtype;

   c2 CURSOR FOR
      SELECT d.ds_tabela,
             d.nr_identificador, 
             h.ds_valor_dominio, 
             b.ds_resultado
        from dar_dashboard          a,
             dar_dashboard_filter   b,
             dar_tab_control_fields d,
             dominio                g,
             valor_dominio          h,
             dar_dashboard_tabs     i
       where CASE WHEN ie_tab=0 THEN  a.nr_sequencia WHEN ie_tab=1 THEN  i.nr_sequencia END  = nr_sequencia_p
         and CASE WHEN ie_tab=0 THEN  a.nr_sequencia WHEN ie_tab=1 THEN  i.nr_seq_dashboard END  = b.nr_seq_dashboard
         and b.nm_campo = d.nr_sequencia
         and g.cd_dominio = Dominio_Where
         and g.cd_dominio = h.cd_dominio
         and h.vl_dominio = b.ie_operacao
         and ((ie_tab = 1 and i.nr_seq_dashboard = a.nr_sequencia) or (ie_tab = 0 and coalesce(i.nr_sequencia::text, '') = ''));

       r2 c2%rowtype;

  c3 CURSOR FOR
      SELECT d.ds_tabela,
             d.nr_identificador,
             h.ds_valor_dominio,
             b.ds_resultado,
             h.vl_dominio
        from dar_dashboard          a,
             dar_dash_global_filter b,
             dar_tab_control_fields c,
             dar_tab_control_fields d,
             dominio                g,
             valor_dominio          h,
             dar_dashboard_tabs     i
       where CASE WHEN ie_tab=0 THEN  a.nr_sequencia WHEN ie_tab=1 THEN  i.nr_sequencia END  = nr_sequencia_p
         and a.nr_seq_app = b.nr_seq_app
         and b.nm_campo = d.nr_sequencia
         and g.cd_dominio = Dominio_Where
         and g.cd_dominio = h.cd_dominio
         and h.vl_dominio = b.ie_operacao
         and c.nr_sequencia = CASE WHEN ie_tab=0 THEN  coalesce(a.nr_seq_dimensao, a.nr_seq_quantitativo) WHEN ie_tab=1 THEN  coalesce(i.nr_seq_dimensao, i.nr_seq_quantitativo) END
         and b.nr_seq_datamodel = c.nr_seq_table_control
         and ((ie_tab = 1 and i.nr_seq_dashboard = a.nr_sequencia) or (ie_tab = 0 and coalesce(i.nr_sequencia::text, '') = ''));

       r3 c3%rowtype;

   ds_sql_w          varchar(4000);
   ds_where_w        varchar(4000);
   ds_where_global_w varchar(4000);
   data_type_w       user_tab_cols.data_type%type;


BEGIN
   --
   ds_sql_w := 'select ''Grafic Tasy'' ds_valores, 0 valor_eixo_x, 0 valor_eixo_y from dual';

   open c1;
   loop
      fetch c1
         into r1;
      EXIT WHEN NOT FOUND; /* apply on c1 */

      open c2;
      loop
         fetch c2
            into r2;
         EXIT WHEN NOT FOUND; /* apply on c2 */

            select max(a.data_type)
              into STRICT data_type_w
              from user_tab_cols a
             where upper(a.table_name) = upper(trim(both r1.nm_tabela))
               and upper(a.column_name) = upper(trim(both r2.nr_identificador));


         if (data_type_w = 'DATE') then
            ds_where_w := ds_where_w || ' and trunc(' || r2.nr_identificador || ') ' || r2.ds_valor_dominio  || 'trunc(to_date(''' || r2.ds_resultado || ''',''' || 'MM/DD/YY' || '''))';
         else
            ds_where_w := ds_where_w || ' and ' ||  r2.nr_identificador || ' ' ||  r2.ds_valor_dominio ||  '''' || r2.ds_resultado ||  '''';
         end if;

      end loop;
      close c2;

      open c3;
      loop
         fetch c3
            into r3;
         EXIT WHEN NOT FOUND; /* apply on c3 */

            select max(a.data_type)
              into STRICT data_type_w
              from user_tab_cols a
             where upper(a.table_name) = upper(trim(both r1.nm_tabela))
               and upper(a.column_name) = upper(trim(both r3.nr_identificador));

         if (data_type_w = 'DATE') then

            ds_where_global_w := ds_where_global_w || ' and trunc(' || r3.nr_identificador || ') ' || r3.ds_valor_dominio  || 'trunc(to_date(''' || r3.ds_resultado || ''',''' || 'MM/DD/YY' || '''))';
         else
            if (r3.vl_dominio = 11) then
               ds_where_global_w := ds_where_global_w || ' and ' ||  r3.nr_identificador || ' ' ||  r3.ds_valor_dominio ||  '''(' || r3.ds_resultado ||  ')''';
            else
               ds_where_global_w := ds_where_global_w || ' and ' ||  r3.nr_identificador || ' ' ||  r3.ds_valor_dominio ||  '''' || r3.ds_resultado ||  '''';
            end if;
         end if;

      end loop;
      close c3;

      if (coalesce(r1.nr_seq_quantitativo::text, '') = '' AND r1.nr_seq_dimensao = 2) then
        r1.nr_seq_quantitativo := r1.nr_seq_dimensao;
      end if;

      ds_sql_w := 'Select ''' || r1.ds_app || ''' ds_valores,'
               || '      ''' || r1.ds_campo_x || ''' ds_valores_x,'
               || '      ''' || r1.ds_campo_y || ''' ds_valores_Y,'
               || '       ' || coalesce(r1.nr_seq_dimensao, 'NULL') || ' valor_eixo_x,' 
               || '       ' || r1.ds_valor_dominio || '( ' || r1.nr_seq_quantitativo || ') valor_eixo_y,  '
               || '      ''' || r1.ds_valor_dominio || '(' || r1.ds_campo_y || ')'' ds_kpi'
               || '  from ' || r1.nm_tabela 
               || ' where 1=1  ' 
               || ds_where_w
               || ds_where_global_w
               || ' group by ''' || r1.ds_app || '''' || CASE WHEN (r1.nr_seq_dimensao IS NOT NULL AND r1.nr_seq_dimensao::text <> '') THEN ', ' || r1.nr_seq_dimensao ELSE NULL END || ' order by valor_eixo_y';

   end loop;
   close c1;

   ds_sql_p := ds_sql_w;

   if (ds_sql_w IS NOT NULL AND ds_sql_w::text <> '') then
     begin 
       if ie_tab = 1 then
         update dar_dashboard_tabs t
            set t.ds_sql = ds_sql_w 
          where t.nr_sequencia = nr_sequencia_p;
       else
         update dar_dashboard t
            set t.ds_sql = ds_sql_w
          where t.nr_sequencia = nr_sequencia_p;
       end if;
     exception when no_data_found then
       null;
     end;
   end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dar_prepara_sql_grafico ( nr_sequencia_p dar_dashboard.nr_sequencia%type, ds_sql_p INOUT text, ie_tab bigint ) FROM PUBLIC;
