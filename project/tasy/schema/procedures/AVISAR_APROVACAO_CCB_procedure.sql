-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE avisar_aprovacao_ccb (nr_seq_impacto_p bigint, ie_status_p text) AS $body$
DECLARE


ie_type_user_w			varchar(3);
ds_email_w				varchar(255);	
ds_email_ori_w			varchar(255);
ds_email_titulo_w   	varchar(255);
ds_email_corpo_w    	varchar(255);
nr_seq_gerencia_w		bigint;
nm_pessoa_fisica_w		varchar(80);
nr_seq_ordem_serv_w		bigint;
ie_impacto_requisito_w	varchar(1);

c01 CURSOR FOR
	SELECT 'SM',
			x.ds_email,
			SUBSTR(obter_nome_pf(x.cd_pessoa_fisica),1,80)
	FROM   	gerencia_wheb a,
			usuario x
	WHERE  	a.cd_responsavel = x.cd_pessoa_fisica 
	AND	   	a.nr_sequencia 	 = nr_seq_gerencia_w
	AND		EXISTS ( SELECT 1
			     FROM  man_ordem_serv_aprov_ccb x,
				 	   man_ordem_serv_impacto y,
					   ccb_equipe z
				 WHERE x.nr_seq_impacto 	  = y.nr_sequencia
				 AND   z.nr_sequencia 		  = x.nr_seq_equipe
			   	 AND   x.nr_seq_impacto		  = nr_seq_impacto_p
				 AND   z.ie_tipo_equipe IN ('SM')
				)	
	
UNION
 
	SELECT 	DISTINCT 'BA',
			a.ds_email,
			SUBSTR(obter_nome_pf(a.cd_pessoa_fisica),1,80)
	FROM   	usuario a,
			usuario_grupo_des b,
			grupo_desenvolvimento c,
			gerencia_wheb d 
	WHERE  	a.nm_usuario       	= b.nm_usuario_grupo 
	AND     c.nr_sequencia     	= b.nr_seq_grupo 
	AND     d.nr_sequencia      = c.nr_seq_gerencia
	AND     d.nr_sequencia      = nr_seq_gerencia_w 
	AND		EXISTS ( SELECT 1
				     FROM	ccb_equipe x,
					 		CCB_EQUIPE_REGRA y
					 WHERE	x.nr_sequencia 	  		 = y.nr_seq_equipe
					 AND	y.cd_pessoa_fisica 		 = a.cd_pessoa_fisica
					 AND	x.ie_tipo_equipe IN ('BA')
					 ) 
	AND		EXISTS ( SELECT 1
			     FROM  man_ordem_serv_aprov_ccb x,
				 	   man_ordem_serv_impacto y,
					   ccb_equipe z
				 WHERE x.nr_seq_impacto 	  = y.nr_sequencia
				 AND   z.nr_sequencia 		  = x.nr_seq_equipe
			   	 AND   x.nr_seq_impacto		  = nr_seq_impacto_p
				 AND   z.ie_tipo_equipe IN ('BA')
				)
	
UNION

	SELECT 	DISTINCT 'ALL',
			x.ds_email,
			SUBSTR(obter_nome_pf(x.cd_pessoa_fisica),1,80)
	FROM   	ccb_equipe a,
			ccb_equipe_regra b,
			usuario x
	WHERE  	a.nr_sequencia 	  		= b.nr_seq_equipe
	AND	   	b.cd_pessoa_fisica 	  	= x.cd_pessoa_fisica 
	AND		coalesce(a.ie_situacao,'A') 	= 'A'
	AND     a.ie_tipo_equipe IN ('CM','PM','QR','VV')
	AND	   	clock_timestamp() BETWEEN inicio_dia(b.dt_inicio) AND fim_dia(b.dt_fim)
	AND		EXISTS ( SELECT 1
			     FROM  man_ordem_serv_aprov_ccb x,
				 	   man_ordem_serv_impacto y
				 WHERE x.nr_seq_impacto 	  = y.nr_sequencia
				 AND   a.nr_sequencia 		  = x.nr_seq_equipe
			   	 AND   x.nr_seq_impacto		  = nr_seq_impacto_p
				 AND   a.ie_tipo_equipe IN ('CM','PM','QR','VV')
				)
  
union

  select 'CL', 
       x.ds_email,
       SUBSTR(obter_nome_pf(x.cd_pessoa_fisica),1,80)
  from  FUNCAO_GRUPO_DES a,
      MAN_ORDEM_SERVICO b,
      GRUPO_DESENVOLVIMENTO c,
      gerencia_wheb d,
      usuario x
  where a.cd_funcao = b.cd_funcao
  and   c.nr_sequencia = a.nr_seq_grupo
  and   d.nr_sequencia = c.nr_seq_gerencia
  and   a.cd_funcao = b.cd_funcao 
  and   x.cd_pessoa_fisica = d.cd_responsavel
  and   b.nr_sequencia = nr_seq_ordem_serv_w
  and   d.nr_sequencia <> nr_seq_gerencia_w
  and  exists ( select 1
              from  REG_PRODUCT_REQUIREMENT y,
                    MAN_ORDEM_SERV_IMP_PR z
              where y.nr_sequencia   = z.NR_PRODUCT_REQUIREMENT
              and   z.nr_seq_impacto   = nr_seq_impacto_p
              and   y.ie_clinico     = 'S');

BEGIN

if (nr_seq_impacto_p IS NOT NULL AND nr_seq_impacto_p::text <> '') then

	SELECT 	max(nr_seq_ordem_serv)
	into STRICT	nr_seq_ordem_serv_w
	FROM   	man_ordem_serv_impacto
	WHERE  	nr_sequencia = nr_seq_impacto_p;	
	
	select 	CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
	into STRICT 	ie_impacto_requisito_w
	from 	man_ordem_serv_imp_pr
	where 	nr_seq_impacto = nr_seq_impacto_p
	and 	ie_impacto_requisito in ('I', 'A', 'E');	
	
	select	max(a.nr_seq_gerencia)
	into STRICT	nr_seq_gerencia_w
	from	grupo_desenvolvimento a,
			man_ordem_servico b
	where	a.nr_sequencia = b.nr_seq_grupo_des
	and		b.nr_sequencia 	= nr_seq_ordem_serv_w;

	SELECT 	coalesce(max(x.ds_email), 'support.informatics@philips.com')
	into STRICT	ds_email_ori_w
	FROM   	man_ordem_serv_impacto a,
			usuario x
	WHERE 	x.nm_usuario 		= a.nm_usuario
	AND	   	nr_seq_ordem_serv 	= nr_seq_ordem_serv_w;

	if (ie_impacto_requisito_w = 'S') then	
		open C01;
		loop
		fetch c01 into
			ie_type_user_w,
			ds_email_w,
			nm_pessoa_fisica_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */

		BEGIN
					
		 if (ds_email_ori_w IS NOT NULL AND ds_email_ori_w::text <> '') and (ds_email_w IS NOT NULL AND ds_email_w::text <> '') then
			if (ie_status_p = 'R') then
				ds_email_titulo_w	:= obter_desc_expressao(953869);
				ds_email_corpo_w	:= replace(replace(obter_desc_expressao(953871), '#@NM_PESSOA_FISICA#@', nm_pessoa_fisica_w), '#@NR_SEQ_ORDEM_SERV#@', nr_seq_ordem_serv_w);
			else
				if (ie_type_user_w = 'CL') then
					--Pendente a alteracao da expressao
					ds_email_titulo_w	:= 'MDF -'|| obter_desc_expressao(921562);
				else
					ds_email_titulo_w := obter_desc_expressao(921562);
				end if;
				
				ds_email_corpo_w := replace(replace(obter_desc_expressao(921560), '#@NM_PESSOA_FISICA#@', nm_pessoa_fisica_w), '#@NR_SEQ_ORDEM_SERV#@', nr_seq_ordem_serv_w);
			end if;
			
			CALL enviar_email(ds_email_titulo_w, ds_email_corpo_w, ds_email_ori_w, ds_email_w, 'Tasy', 'M');

			CALL gravar_log_tasy(1515,  nr_seq_ordem_serv_w||'-'||nm_pessoa_fisica_w||'-'||ds_email_w, 'Tasy');
				
		end if;
			exception
				when others then
				CALL gravar_log_tasy(1414, nm_pessoa_fisica_w, 'Tasy');
				
		END;
		end loop;
		close C01;
	end if;		
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE avisar_aprovacao_ccb (nr_seq_impacto_p bigint, ie_status_p text) FROM PUBLIC;

