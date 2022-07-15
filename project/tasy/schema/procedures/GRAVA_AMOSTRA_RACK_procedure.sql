-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_amostra_rack (nm_usuario_p text, cd_barras_p text, cd_estab_p bigint, nr_seq_armazem_rack_p bigint, nr_seq_lab_am_rack_p bigint, amostra_gravada_p INOUT text) AS $body$
DECLARE

                             
ie_padrao_amostra_w       lab_parametro.ie_padrao_amostra%type;
nr_prescricao_w           prescr_procedimento.nr_prescricao%type;
nr_seq_prescr_w           prescr_procedimento.nr_sequencia%type;
dt_prior_codigo_barras_w  varchar(2);
gravado_w                 varchar(1);
nr_linha_w                smallint;
nr_coluna_w               integer;
ie_forma_insercao_w       varchar(5);
qt_barras_w               bigint;
prescricao_valida_w       char(1);
nr_seq_lab_soro_am_rack_w lab_soro_amostra_rack.nr_sequencia%type;
nr_sequencia_info_w       lab_soro_processo_info.nr_sequencia%type;
cd_barras_formatado_w     prescr_proc_mat_item.cd_barras%type;
cd_material_exame_w       material_exame_lab.cd_material_exame%type;
nr_Seq_material_w         material_exame_lab.nr_sequencia%type;

nr_seq_exame_w exame_laboratorio.nr_seq_exame%type;
barras_padrao_amostra_w  varchar(15);
qt_prescr_barras_material_w bigint;
separador_barras_material_w bigint;
separador_barras_exame_w bigint;

c01 CURSOR FOR
  SELECT  a.nr_prescricao,
          a.nr_sequencia
    FROM  prescr_procedimento a,
          prescr_proc_mat_item g
    WHERE a.nr_prescricao = g.nr_prescricao              
      AND a.nr_sequencia = g.nr_seq_prescr 
      and g.cd_barras = cd_barras_formatado_w;

c02 CURSOR FOR
  SELECT  a.nr_prescricao,
          a.nr_sequencia
    FROM  prescr_procedimento a
    where  nr_prescricao = nr_prescricao_w
    and CD_MATERIAL_EXAME = CD_MATERIAL_EXAME_w;

c03 CURSOR FOR
  SELECT  a.nr_prescricao,
          a.nr_sequencia
    FROM  prescr_procedimento a
    where  nr_prescricao = nr_prescricao_w
    and  nr_seq_exame = nr_seq_exame_w;


BEGIN


  select max(ie_padrao_amostra)
    into STRICT ie_padrao_amostra_w
    from lab_parametro 
   where cd_estabelecimento = cd_estab_p;

  dt_prior_codigo_barras_w := lab_obter_valor_parametro(722,373);
  
  gravado_w := 'N';
  separador_barras_material_w := position('M' in cd_barras_p);
  separador_barras_exame_w := position('E' in cd_barras_p);

  if (ie_padrao_amostra_w in ('AMO9','AMO10','AMO11','AM11F','AM10F','AMO13','WEB')) then
    cd_barras_formatado_w := to_char((cd_barras_p)::numeric );
  else
   cd_barras_formatado_w := cd_barras_p;
  end if;

  select count(*)
  into STRICT qt_barras_w
  from prescr_proc_material
  where cd_barras = cd_barras_formatado_w;

  if (qt_barras_w = 0) then

	if (separador_barras_material_w > 0) then
	
		nr_Seq_material_w := substr(cd_barras_p,separador_barras_material_w+1,length(cd_barras_p));
		nr_prescricao_w := substr(cd_barras_p,1,separador_barras_material_w-1);
		
		begin
			select cd_material_exame
			into STRICT cd_material_exame_w
			from material_exame_lab
			where nr_sequencia = nr_Seq_material_w;
		exception
			when no_data_found then
			cd_material_exame_w := '';
		end;
		
		select CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT prescricao_valida_w
		from prescr_procedimento
		where nr_prescricao = nr_prescricao_w
		and cd_material_exame = cd_material_exame_w;
	
	elsif (separador_barras_exame_w > 0) then
	
		nr_seq_exame_w := substr(cd_barras_p,separador_barras_exame_w+1,length(cd_barras_p));

		nr_prescricao_w := substr(cd_barras_p,1,separador_barras_exame_w-1);
		
		select CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT prescricao_valida_w
		from prescr_procedimento
		where nr_prescricao = nr_prescricao_w
		and nr_seq_exame = nr_seq_exame_w;

	end if;
	
  else
	prescricao_valida_w := 'S';
  end if;

  
  if (prescricao_valida_w = 'S') then
    if (coalesce(nr_seq_lab_am_rack_p::text, '') = '') then
      begin
        select coalesce(lsr.ie_forma_insercao, lab_obter_valor_parametro(728,1)) ie_forma_insercao
          into STRICT ie_forma_insercao_w
          from LAB_SORO_ARMAZENA_RACK LSAR
          left outer join lab_soro_rack lsr on lsr.nr_sequencia = lsar.nr_seq_rack 
         where LSAR.nr_sequencia = nr_seq_armazem_rack_p;

        if ((ie_forma_insercao_w = 'UBLRL') or (ie_forma_insercao_w = 'UBRLL')) then
          select min(nr_pos_linha)
            into STRICT nr_linha_w
            from lab_soro_amostra_rack
           where ie_status = 'L' and
                 nr_seq_armazem_rack = nr_seq_armazem_rack_p;

          if (ie_forma_insercao_w = 'UBLRL') then /*De cima para baixo, da esquerda para direita (linha)*/
          
            select min(nr_pos_coluna)
              into STRICT nr_coluna_w
              from lab_soro_amostra_rack
             where ie_status = 'L' and
                   nr_pos_linha = nr_linha_w and
                   nr_seq_armazem_rack = nr_seq_armazem_rack_p;

          elsif (ie_forma_insercao_w = 'UBRLL') then /*De cima para baixo, da direita para esquerda (linha)*/
          
            select max(nr_pos_coluna)
              into STRICT nr_coluna_w
              from lab_soro_amostra_rack
             where ie_status = 'L' and
                   nr_pos_linha = nr_linha_w and           
                   nr_seq_armazem_rack = nr_seq_armazem_rack_p;
          end if;
                 
        elsif ((ie_forma_insercao_w = 'BULRL') or (ie_forma_insercao_w = 'BURLL')) then
          select max(nr_pos_linha)
            into STRICT nr_linha_w
            from lab_soro_amostra_rack
           where ie_status = 'L' and
                 nr_seq_armazem_rack = nr_seq_armazem_rack_p;

          if (ie_forma_insercao_w = 'BULRL') then /*De baixo para cima, da esquerda para direita (linha)*/
            select min(nr_pos_coluna)
              into STRICT nr_coluna_w
              from lab_soro_amostra_rack
             where ie_status = 'L' and
                   nr_pos_linha = nr_linha_w and
                   nr_seq_armazem_rack = nr_seq_armazem_rack_p;
                 
          elsif (ie_forma_insercao_w = 'BURLL') then /*De baixo para cima, da direita para esquerda (linha)*/
            select max(nr_pos_coluna)
              into STRICT nr_coluna_w
              from lab_soro_amostra_rack
             where ie_status = 'L' and
                   nr_pos_linha = nr_linha_w and           
                   nr_seq_armazem_rack = nr_seq_armazem_rack_p;
          end if;
                 
        elsif ((ie_forma_insercao_w = 'BULRC') or (ie_forma_insercao_w = 'UBLRC')) then
          select min(nr_pos_coluna)
            into STRICT nr_coluna_w
            from lab_soro_amostra_rack
           where ie_status = 'L' and
                 nr_seq_armazem_rack = nr_seq_armazem_rack_p;

          if (ie_forma_insercao_w = 'BULRC') then /*De baixo para cima, da esquerda para direita (coluna)*/
                 
            select max(nr_pos_linha) 
              into STRICT nr_linha_w
              from lab_soro_amostra_rack
             where ie_status = 'L' and
                   nr_pos_coluna = nr_coluna_w and
                   nr_seq_armazem_rack = nr_seq_armazem_rack_p;

          elsif (ie_forma_insercao_w = 'UBLRC') then /*De cima para baixo, da esquerda para direita (coluna)*/
            select min(nr_pos_linha)
              into STRICT nr_linha_w
              from lab_soro_amostra_rack
             where ie_status = 'L' and
                   nr_pos_coluna = nr_coluna_w and           
                   nr_seq_armazem_rack = nr_seq_armazem_rack_p;
          end if;
                 
        elsif ((ie_forma_insercao_w = 'BURLC') or (ie_forma_insercao_w = 'UBRLC')) then
          select max(nr_pos_coluna)
            into STRICT nr_coluna_w
            from lab_soro_amostra_rack
           where ie_status = 'L' and
                 nr_seq_armazem_rack = nr_seq_armazem_rack_p;

          if (ie_forma_insercao_w = 'BURLC') then /*De baixo para cima, da direita para esquerda (coluna)*/
            select max(nr_pos_linha) 
              into STRICT nr_linha_w
              from lab_soro_amostra_rack
             where ie_status = 'L' and
                   nr_pos_coluna = nr_coluna_w and
                   nr_seq_armazem_rack = nr_seq_armazem_rack_p;
                 
          elsif (ie_forma_insercao_w = 'UBRLC') then /*De cima para baixo, da direita para esquerda (coluna)*/
            select min(nr_pos_linha)
              into STRICT nr_linha_w
              from lab_soro_amostra_rack
             where ie_status = 'L' and
                   nr_pos_coluna = nr_coluna_w and           
                   nr_seq_armazem_rack = nr_seq_armazem_rack_p;
          end if;
        end if;
        
        select max(nr_sequencia)
          into STRICT nr_seq_lab_soro_am_rack_w
          from lab_soro_amostra_rack
         where nr_pos_linha = nr_linha_w and
               nr_pos_coluna = nr_coluna_w;

      end;
    else 
      nr_seq_lab_soro_am_rack_w := nr_seq_lab_am_rack_p;
    end if;

    update lab_soro_amostra_rack set ds_amostra = cd_barras_p, ie_status = 'O'
     where nr_sequencia = nr_seq_lab_soro_am_rack_w;

    select max(nr_sequencia)
      into STRICT nr_sequencia_info_w
      from lab_soro_processo_info
     where IE_ACAO = 'AR' and
           nr_seq_armazena_rack = nr_seq_armazem_rack_p and
           coalesce(nr_seq_amostra_rack::text, '') = '';

    if (coalesce(nr_sequencia_info_w::text, '') = '') then
      insert into lab_soro_processo_info(nr_sequencia,
                                          ie_acao,
                                          dt_acao,
                                          nr_seq_armazena_rack,
                                          nr_seq_amostra_rack,
                                          dt_atualizacao,
                                          nm_usuario)
                                  values (nextval('lab_soro_processo_info_seq'),
                                          'AR',
                                          clock_timestamp(), 
                                          nr_seq_armazem_rack_p,
                                          nr_seq_lab_soro_am_rack_w,
                                          clock_timestamp(),
                                          nm_usuario_p);
    else
      update lab_soro_processo_info set dt_acao = clock_timestamp(), 
                                        dt_atualizacao = clock_timestamp(),
                                        nm_usuario = nm_usuario_p,
                                        nr_seq_amostra_rack = nr_seq_lab_soro_am_rack_w
      where nr_sequencia = nr_sequencia_info_w;
    end if;
	
    if (qt_barras_w > 0) then /*Executa quando o código de barras está inserido na tabela prescr_proc_mat_item*/
	    open C01;
	    loop
	      fetch c01 into	
		nr_prescricao_w,
		nr_seq_prescr_w;
	      EXIT WHEN NOT FOUND; /* apply on c01 */
		CALL inserir_amostra_rack( nm_usuario_p, nr_prescricao_w, nr_seq_prescr_w, nr_seq_lab_soro_am_rack_w);
	    end loop;
	    close c01;
	    gravado_w := 'S';

    elsif (separador_barras_material_w > 0) then /*Executa quando o código de barras é Prescrição + Material*/
                    open C02;
	    loop					
	      fetch c02 into	nr_prescricao_w,
    	                	nr_seq_prescr_w;
	      EXIT WHEN NOT FOUND; /* apply on c02 */
    		CALL Inserir_Amostra_Rack( nm_usuario_p, nr_prescricao_w, nr_seq_prescr_w, nr_seq_lab_soro_am_rack_w);
	    end loop;
	    close c02;
	    gravado_w := 'S';

    elsif (separador_barras_exame_w > 0) then /*Executa quando o código de barras é Prescrição + Exame*/
 	    open C03;
	    loop			
	      fetch c03 into nr_prescricao_w,
                    	 nr_seq_prescr_w;
	      EXIT WHEN NOT FOUND; /* apply on c03 */
     		CALL Inserir_Amostra_Rack( nm_usuario_p, nr_prescricao_w, nr_seq_prescr_w, nr_seq_lab_soro_am_rack_w);
	    end loop;
	    close c03;
	    gravado_w := 'S';

    end if;
  end if;

  commit;
  amostra_gravada_p := gravado_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_amostra_rack (nm_usuario_p text, cd_barras_p text, cd_estab_p bigint, nr_seq_armazem_rack_p bigint, nr_seq_lab_am_rack_p bigint, amostra_gravada_p INOUT text) FROM PUBLIC;

