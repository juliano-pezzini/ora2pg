-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_material_preco_dia () AS $body$
DECLARE

DT_ATUALIZACAO_W     timestamp     := clock_timestamp();
CD_ESTABELECIMENTO_W   smallint  := 1;
CD_MATERIAL_W       integer  := 0;
CD_CONVENIO_W       integer  := 0;
CD_CATEGORIA_W      varchar(10);
VL_PRECO_MATERIAL_W    double precision := 0;
DT_ULTIMA_VIGENCIA_W   timestamp	    := clock_timestamp();
CD_TAB_PRECO_MATERIAL_W  smallint 	:= 0;
IE_ORIGEM_PRECO_W     smallint	:= 0;

CD_TIPO_ACOMODACAO_W     smallint;
IE_TIPO_ATENDIMENTO_W     smallint;
CD_SETOR_ATENDIMENTO_W    integer;
CD_CGC_FORNECEDOR_W		varchar(14) := '';
nr_seq_bras_preco_w		bigint;
nr_seq_mat_bras_w		bigint;
nr_seq_conv_bras_w		bigint;
nr_seq_conv_simpro_w		bigint;
nr_seq_mat_simpro_w		bigint;
nr_seq_simpro_preco_w		bigint;
nr_seq_ajuste_mat_w		bigint;

C01 CURSOR FOR 
   SELECT cd_material 
    from material_atend_paciente 
    where dt_atendimento between(clock_timestamp() - interval '30 days') 
                and clock_timestamp() 
    group by cd_material 
    having count(*) > 150;

C02 CURSOR FOR 
   SELECT cd_convenio, cd_categoria 
    from categoria_convenio 
    where ie_situacao = 'A' 
    order by cd_convenio, cd_categoria;


BEGIN 
CD_TIPO_ACOMODACAO_W     := NULL;
IE_TIPO_ATENDIMENTO_W     := NULL;
CD_SETOR_ATENDIMENTO_W    := NULL;
 
/* Limpar tabela Material_Preco_Dia */
 
begin 
DELETE FROM Material_Preco_Dia;
COMMIT;
end;
 
/* Gerar tabela Material_Preco_Dia */
 
OPEN C01;
LOOP 
  FETCH C01 into CD_MATERIAL_W;
  if  C01%FOUND then 
	begin 
	OPEN C02;
	LOOP 
  	  FETCH C02 into CD_CONVENIO_W, 
             CD_CATEGORIA_W;
  	  if  C02%FOUND then 
		begin 
        SELECT * FROM Define_Preco_Material(CD_ESTABELECIMENTO_W, CD_CONVENIO_W, CD_CATEGORIA_W, DT_ATUALIZACAO_W, CD_MATERIAL_W, CD_TIPO_ACOMODACAO_W, IE_TIPO_ATENDIMENTO_W, CD_SETOR_ATENDIMENTO_W, CD_CGC_FORNECEDOR_W, 0, 0, null, null, null, null, null, null, null, null, VL_PRECO_MATERIAL_W, DT_ULTIMA_VIGENCIA_W, CD_TAB_PRECO_MATERIAL_W, IE_ORIGEM_PRECO_W, nr_seq_bras_preco_w, nr_seq_mat_bras_w, nr_seq_conv_bras_w, nr_seq_conv_simpro_w, nr_seq_mat_simpro_w, nr_seq_simpro_preco_w, nr_seq_ajuste_mat_w) INTO STRICT VL_PRECO_MATERIAL_W, DT_ULTIMA_VIGENCIA_W, CD_TAB_PRECO_MATERIAL_W, IE_ORIGEM_PRECO_W, nr_seq_bras_preco_w, nr_seq_mat_bras_w, nr_seq_conv_bras_w, nr_seq_conv_simpro_w, nr_seq_mat_simpro_w, nr_seq_simpro_preco_w, nr_seq_ajuste_mat_w;
        INSERT INTO MATERIAL_PRECO_DIA(cd_estabelecimento, 
			cd_convenio, 
			cd_categoria, 
			cd_material, 
			vl_unitario, 
			dt_ultima_vigencia, 
			dt_atualizacao, 
			nm_usuario, 
			cd_tab_preco_mat, 
			ie_origem_preco) 
       	VALUES (cd_estabelecimento_w, 
			cd_convenio_w, 
			cd_categoria_w, 
			cd_material_w, 
			vl_preco_material_w, 
			dt_ultima_vigencia_w, 
			dt_atualizacao_w, 
			'Tasy', 
			cd_tab_preco_material_w, 
			ie_origem_preco_w);
		end;
  	  else 
    		exit;
  	  end if;
	END LOOP;
	CLOSE C02;
    	end;
  else 
    	exit;
  end if;
END LOOP;
CLOSE C01;
 
COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_material_preco_dia () FROM PUBLIC;

