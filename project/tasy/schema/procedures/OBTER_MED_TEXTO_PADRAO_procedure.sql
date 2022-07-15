-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_med_texto_padrao ( cd_medico_p text, ie_tipo_texto_p bigint, nr_seq_texto_p bigint, cd_pessoa_fisica_p text, nr_seq_cliente_p bigint, isSubstituirMacro text, nm_usuario_p text, ds_texto_Padrao_p INOUT text) AS $body$
DECLARE

 
/** 
 ie_tipo_texto_p 
 1 - Texto (MED_TEXTO_ADICIONAL) 
 2 - Receita Médica ( MED_RECEITA ) 
 3 - Solicitação de Exames ( MED_PEDIDO_EXAME ) 
 4 - Atestado  (MED_ATESTADO) 
 8 - Evolução (MED_EVOLUCAO) 
 9 - Diagnóstico - (MED_PAC_DIAGNOSTICO) 
 
*/
 
 
 
dados_clinicos_w varchar(255);
ds_texto_banco_w text;
ds_macro_w  varchar(4000);
nm_atrib_macro_w varchar(50);
ds_valor_w  varchar(100);
pos_macro_w  integer;
qtd   bigint := 0;

 
 
C01 CURSOR FOR 
 SELECT ds_macro, 
  nm_atributo 
 from med_macro_texto 
 where 1 = 1 
 order by ds_macro;


BEGIN 
--execute inserir_texto_padrao('740015', 3, 1432, '4', 2736, '740015', 'Juliane') 
 
-- Buscar o texto Padrão 
select ds_dados_clinicos, 
 ds_texto 
into STRICT 
 dados_clinicos_w, 
 ds_texto_banco_w 
from  med_texto_padrao 
where  ie_tipo_texto  = ie_tipo_texto_p 
and   cd_medico    = cd_medico_p 
and nr_sequencia = nr_seq_texto_p;
 
 
 
if ( isSubstituirMacro = 'S' ) then 
 OPEN C01;
 LOOP 
 FETCH C01 into 
 ds_macro_w, 
 nm_atrib_macro_w;
 EXIT WHEN NOT FOUND; /* apply on c01 */
 begin 
  pos_macro_w := position(ds_macro_w in ds_texto_banco_w);
 
 if (upper(nm_atrib_macro_w) = 'CD_PESSOA_FISICA') then 
  ds_valor_w := cd_pessoa_fisica_p;
 elsif (upper(nm_atrib_macro_w) = 'NR_SEQ_CLIENTE') then 
  ds_valor_w := nr_seq_cliente_p;
 else 
  ds_valor_w := clock_timestamp();
 end if;
 
 if (pos_macro_w > 0) then 
  select coalesce(max(substituir_macro_texto(upper(ds_macro_w), upper(nm_atrib_macro_w), ds_valor_w)), obter_desc_expressao(327119)/*'Não Informado'*/
) 
  into STRICT ds_valor_w 
;
  ds_texto_banco_w := replace(ds_texto_banco_w, ds_macro_w, ds_valor_w);
 end if;
 end;
 END LOOP;
 CLOSE C01;
end if;
 
commit;
ds_texto_Padrao_p := ds_texto_banco_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_med_texto_padrao ( cd_medico_p text, ie_tipo_texto_p bigint, nr_seq_texto_p bigint, cd_pessoa_fisica_p text, nr_seq_cliente_p bigint, isSubstituirMacro text, nm_usuario_p text, ds_texto_Padrao_p INOUT text) FROM PUBLIC;

